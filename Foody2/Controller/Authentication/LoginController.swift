//
//  LoginController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-05-31.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase
import KVNProgress

class LoginController: UIViewController, UITextFieldDelegate {
    
    let kLoginTextFieldTag = 1
    
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
        self.loginView.loginAction = handleLogin
        self.loginView.cancelAction = handleCancel
        self.view.addSubview(loginView)
        loginView.setAnchor(top: view.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: view.bottomAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0)
        
        self.loginView.emailTextField.delegate = self
        self.loginView.emailTextField.tag = kLoginTextFieldTag
        self.loginView.passwordTextField.delegate = self
        
    }
    
    // MARK: - UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == kLoginTextFieldTag {
            loginView.passwordTextField.becomeFirstResponder()
        } else {
            handleLogin()
        }
        return false
    }
    
    // MARK: - Events
    func handleLogin() {
        
        validateForm()
        
        guard let email = loginView.emailTextField.text, email.isValidEmail(), let password = loginView.passwordTextField.text, loginView.passwordTextField.text != "" else {
            print("Wrong user data")
            return
        }
        print("email: \(email)")
        print("password: \(password)")
        
        KVNProgress.show(withStatus: "Loading...")
        Auth.auth().signIn(withEmail: email, password: password) { (loginResult, error) in
            if error != nil {
                print(error!)
                KVNProgress.showError(withStatus: "Wrong email or password.")
                return
            }
            
            KVNProgress.dismiss()
            let tabBarVC = TabBarController()
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    private func validateForm() {
        if !loginView.emailTextField.text!.isValidEmail() {
            loginView.emailTextField.showWarning()
        } else {
            loginView.emailTextField.rightViewMode = .never
        }
        
        if loginView.passwordTextField.text == "" {
            loginView.passwordTextField.showWarning()
        } else {
            loginView.passwordTextField.rightViewMode = .never
        }

    }
}

