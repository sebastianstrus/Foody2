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

            let values = ["name" : name, "email": email] as [String : AnyObject]
            //successfully authenticated user
            self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
            
        }
    }
    
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func imageViewTapped() {
        print("imageTapped")
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
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://foody-4454f.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        //let values = ["name" : name, "email": email]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("Couldn't save child values")
                print(err!)
                return
            }
            
            print("User saved successfully into Firebase database")
            let tabBarVC = TabBarController()
            self.present(tabBarVC, animated: true, completion: nil)
        })
    }
    
}
