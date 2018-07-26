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

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate  {
    
    var signUpView: SignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    func setupViews() {
        let signUpView = SignUpView(frame: self.view.frame)
        self.signUpView = signUpView
        self.signUpView.submitAction = submitPressed
        self.signUpView.cancelAction = cancelPressed
        self.signUpView.selectProfileImageViewAction = imageViewTapped
        view.addSubview(signUpView)
    }
    
    // MARK: - Events
    func submitPressed() {
        guard let name = signUpView.nameTF.text, let email = signUpView.emailTF.text, let password = signUpView.passwordTF.text else {
            print("Wrong user data")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = authResult?.user.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = self.signUpView.profileImageView.image!.pngData() {
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
    
    func cancelPressed() {
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
    
    // MARK: - Helpers
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://foody-4454f.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("Couldn't save child values")
                print(err!)
                return
            }
            
            print("User saved successfully into Firebase database")
            self.clearForm()
            let tabBarVC = TabBarController()
            self.present(tabBarVC, animated: true, completion: nil)
        })
    }
    
    private func clearForm() {
        signUpView.nameTF.text = ""
        signUpView.emailTF.text = ""
        signUpView.passwordTF.text = ""
        signUpView.confirmPasswordTF.text = ""
    }
}
