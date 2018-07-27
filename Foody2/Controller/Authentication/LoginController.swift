//
//  LoginController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-05-31.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupView() {
        self.loginView = LoginView(frame: self.view.frame)
        self.loginView.loginAction = loginPressed
        self.loginView.cancelAction = cancelPressed
        self.view.addSubview(loginView)
        loginView.setAnchor(top: view.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: view.bottomAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0)
    }
    
     // MARK: - Events
    func loginPressed() {
        guard let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text else {
            print("Wrong user data")
            return
        }
        print("email: \(email)")
        print("password: \(password)")
        
        Auth.auth().signIn(withEmail: email, password: password) { (loginResult, error) in
            if error != nil {
                print(error!)
                return
            }
            
            let tabBarVC = TabBarController()
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
    
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}

