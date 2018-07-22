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

    private func setupView() {
        //there is 3 containers in the view
        let mainView = AccountView(frame: self.view.frame)
        self.accountView = mainView
        
        //assign actions
        accountView.cameraAction = cameraPressed
        accountView.libraryAction = libraryPressed
        accountView.logoutAction = logoutPressed
        accountView.removeAccountAction = removeAccountPressed
        
        self.view.addSubview(accountView)
        self.accountView.pinToEdges(view: view)
        

        // get details for current user
        let currentUser = Auth.auth().currentUser
        let uid = currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if let dict = snapshot.value as? [String: AnyObject] {
                let username = dict["name"] as! String
                let email = dict["email"] as! String
                self.accountView.userNameLabel.text = (self.accountView.userNameLabel.text)! + username
                self.accountView.emailLabel.text = (self.accountView.emailLabel.text)! + email
            }
        }
        let creationDate = currentUser?.metadata.creationDate?.formatedString()
        self.accountView.registrationDateLabel.text = (self.accountView.registrationDateLabel.text)! + creationDate!
        
    }
    
    
    //actions
    private func cameraPressed() {
        Swift.print("Camera pressed")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func libraryPressed() {
        Swift.print("Library pressed")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func logoutPressed() {
        Swift.print("Logout pressed")
        let alert = UIAlertController(title: "Logout from Foody", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (UIAlertAction) in
            self.handleLogout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func removeAccountPressed() {
        Swift.print("Remove account pressed")
        let alert = UIAlertController(title: "Remove account from Foody", message: "Are you sure you want to remove your account?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (UIAlertAction) in
            self.handleRemoveAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate functions
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        accountView.profileImageView.image = image
        //saveImageInFirebase() for current user
        self.dismiss(animated: true, completion: nil);
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
        
    }
}
