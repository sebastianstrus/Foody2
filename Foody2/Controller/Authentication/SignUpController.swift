//
//  SignUpController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

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
        Swift.print("Username: \(String(describing: signUpView.nameTextField.text))\nEmail: \(String(describing: signUpView.emailTextField.text))")
    }
    
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}
