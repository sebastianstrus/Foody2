//
//  LoginController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-05-31.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
    
    func loginPressed() {
        print("login pressed")
        let tabBarVC = TabBarController()
        present(tabBarVC, animated: true, completion: nil)
    }
    
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}

