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

class SignUpController: UIViewController {
    
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
        view.addSubview(signUpView)
    }
    
    func submitPressed() {
        guard let name = signUpView.nameTF.text, let email = signUpView.emailTF.text, let password = signUpView.passwordTF.text else {
            print("Wrong user data")
            return
        }
        Swift.print("submitPressed")
        Swift.print(signUpView.nameTF.text!)
        Swift.print(email)
        Swift.print(password)
        Swift.print(signUpView.confirmPasswordTF.text!)

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = authResult?.user.uid else {
                return
            }

            
            //successfully authenticated user
            let ref = Database.database().reference(fromURL: "https://foody-4454f.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name" : name, "email": email]
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
    
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}
