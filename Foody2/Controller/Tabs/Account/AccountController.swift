//
//  AccountController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase

class AccountController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    private var accountView: AccountView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: Strings.ACCOUNT)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUserDetails()
    }

    private func setupView() {
        //there is 3 containers in the view
        let mainView = AccountView(frame: self.view.frame)
        accountView = mainView
        
        //assign actions
        accountView.cameraAction = cameraPressed
        accountView.libraryAction = libraryPressed
        accountView.logoutAction = logoutPressed
        accountView.removeAccountAction = removeAccountPressed
        
        self.view.addSubview(accountView)
        self.accountView.pinToEdges(view: view)
    }
    
    
    // MARK: - Buttons Actions
    private func cameraPressed() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func libraryPressed() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func logoutPressed() {
        let alert = UIAlertController(title: "Logout from Foody", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (UIAlertAction) in
            self.handleLogout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: Device.IS_IPAD ? .default : .cancel, handler: nil))
        
        // support for iPAD:
        if Device.IS_IPAD {
            alert.popoverPresentationController?.sourceView = self.accountView
            alert.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(alert, animated: true)
    }
    
    private func removeAccountPressed() {
        let alert = UIAlertController(title: "Remove account from Foody", message: "Are you sure you want to remove your account?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (UIAlertAction) in
            self.handleRemoveAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: Device.IS_IPAD ? .default : .cancel, handler: nil))
        
        // support for iPAD:
        if Device.IS_IPAD {
            alert.popoverPresentationController?.sourceView = self.accountView
            alert.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        self.present(alert, animated: true)
        
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
            accountView.profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let welcomeController = WelcomeController()
        present(welcomeController, animated: true)
    }
    
    private func handleRemoveAccount() {
        let user = Auth.auth().currentUser
        let userRef = Database.database().reference().child("users").child(user!.uid)
        //userRef.removeValue()
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                userRef.removeValue()
                let welcomeController = WelcomeController()
                self.present(welcomeController, animated: true)
            }
        }
    }
    
    // set details for current user
    func updateUserDetails() {
        

        let currentUser = Auth.auth().currentUser
        let uid = currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
            //let user = UserClass(snapshot: snapshot)
            //user?.photoURL
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let username = dict["name"] as! String
                let email = dict["email"] as! String
                let imageUrl = dict["profileImageUrl"] as! String
                let meals = dict["meals"]
                //print("meals: \(meals)")

                self.accountView.numberOfMealsLabel.text = Strings.SAVED_MEALS_ + "\(meals?.count ?? 0)"
                self.accountView.profileImageView.load(urlString: imageUrl)
                self.accountView.userNameLabel.text = Strings.USERNAME_ + username
                self.accountView.emailLabel.text = Strings.EMAIL_ + email
            }
        }
        let creationDate = currentUser?.metadata.creationDate?.formatedString()
        self.accountView.registrationDateLabel.text = Strings.REG_DATE_ + creationDate!
    }
}
