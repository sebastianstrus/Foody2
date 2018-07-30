//
//  LoginController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-05-31.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    
    var welcomeView: WelcomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupView() {
        playVideo(title: "foody_background")
        let mainView = WelcomeView(frame: self.view.frame)
        self.welcomeView = mainView
        self.welcomeView.toLoginAction = toLoginPressed
        self.welcomeView.toSignupAction = toSignupPressed
        
        self.view.addSubview(welcomeView)
        
        welcomeView.setAnchor(top: view.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0)
    }
    
     // MARK: - Events
    func toLoginPressed() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func toSignupPressed() {
        let signUpController = SignUpController()
        present(signUpController, animated: true, completion: nil)
    }
}

