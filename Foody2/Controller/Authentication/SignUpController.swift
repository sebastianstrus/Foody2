//
//  SignUpController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import KVNProgress

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    let kNameTextFieldTag = 1
    let kEmailTextFieldTag = 2
    let kPasswordTextFieldTag = 3
    
    var signUpView: SignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    func setupViews() {
        let signUpView = SignUpView(frame: self.view.frame)
        self.signUpView = signUpView
        self.signUpView.submitAction = handleSubmit
        self.signUpView.cancelAction = handleCancel
        self.signUpView.selectProfileImageViewAction = imageViewTapped
        view.addSubview(signUpView)
        
        self.signUpView.nameTF.delegate = self
        self.signUpView.nameTF.tag = kNameTextFieldTag
        self.signUpView.emailTF.delegate = self
        self.signUpView.emailTF.tag = kEmailTextFieldTag
        self.signUpView.passwordTF.delegate = self
        self.signUpView.passwordTF.tag = kPasswordTextFieldTag
        self.signUpView.confirmPasswordTF.delegate = self
    }
    
    // MARK: - Events
    func handleSubmit() {
        validateForm()
        
        guard let name = signUpView.nameTF.text, signUpView.nameTF.text != "" else { return }
        guard let email = signUpView.emailTF.text, email.isValidEmail() else { return }
        guard let password = signUpView.passwordTF.text, signUpView.passwordTF.text != "" else { return }
        guard signUpView.confirmPasswordTF.text != "" else { return }
        
        KVNProgress.show(withStatus: "Creating account...")
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                KVNProgress.showError(withStatus: "Couldn't create account.", on: nil)
                print(error!)
                return
            }
            guard let uid = authResult?.user.uid else { return }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = self.signUpView.profileImageView.image!.jpegData(compressionQuality: 0.5) {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                }
            }
        }
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func imageViewTapped() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            signUpView.profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
        textField.resignFirstResponder()
        switch textField.tag {
        case kNameTextFieldTag:
            signUpView.emailTF.becomeFirstResponder()
        case kEmailTextFieldTag:
            signUpView.passwordTF.becomeFirstResponder()
        case kPasswordTextFieldTag:
            signUpView.confirmPasswordTF.becomeFirstResponder()
        default:
            handleSubmit()
        }
        return false
    }
    
    // MARK: - Helpers
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: AppURLs.FOODY_DB)
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                KVNProgress.dismiss()
                print("Couldn't save child values")
                print(err!)
                return
            }
            print("User saved successfully into Firebase")
            self.resetForm()
            KVNProgress.dismiss()
            let tabBarVC = TabBarController()
            self.present(tabBarVC, animated: true, completion: nil)
        })
    }
    
    private func validateForm() {
        if signUpView.nameTF.text == "" {
            signUpView.nameTF.showWarning()
        } else {
            signUpView.nameTF.rightViewMode = .never
        }
        
        if !signUpView.emailTF.text!.isValidEmail() {
            signUpView.emailTF.showWarning()
        } else {
            signUpView.emailTF.rightViewMode = .never
        }
        
        if signUpView.passwordTF.text == "" {
            signUpView.passwordTF.showWarning()
        } else {
            signUpView.passwordTF.rightViewMode = .never
        }
        
        if signUpView.confirmPasswordTF.text == "" {
            signUpView.confirmPasswordTF.showWarning()
        } else {
            signUpView.confirmPasswordTF.rightViewMode = .never
        }
        
        if signUpView.passwordTF.text != signUpView.confirmPasswordTF.text {
            signUpView.passwordTF.showWarning()
            signUpView.confirmPasswordTF.showWarning()
        } else {
            if signUpView.passwordTF.text != "" && signUpView.confirmPasswordTF.text != "" {
                signUpView.passwordTF.rightViewMode = .never
                signUpView.confirmPasswordTF.rightViewMode = .never
            }
        }
    }
    
    private func resetForm() {
        signUpView.nameTF.text = ""
        signUpView.emailTF.text = ""
        signUpView.passwordTF.text = ""
        signUpView.confirmPasswordTF.text = ""
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
