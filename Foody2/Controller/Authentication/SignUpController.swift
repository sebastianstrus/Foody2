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
        guard let email = signUpView.emailTF.text, let password = signUpView.passwordTF.text else {
            print("Wrong user data")
            return
        }
        Swift.print("submitPressed")
        Swift.print(signUpView.nameTF.text!)
        Swift.print(email)
        Swift.print(password)
        Swift.print(signUpView.confirmPasswordTF.text!)
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            //successfully authenticated user
            
        }
    }
    
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}
