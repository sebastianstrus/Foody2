//
//  AccountController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class AccountController: UIViewController {
    
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
        
        
    }
    
    
    //actions
    private func cameraPressed() {
        Swift.print("Camera pressed")
    }
    
    private func libraryPressed() {
        Swift.print("Library pressed")
    }
    
    private func logoutPressed() {
        Swift.print("Logout pressed")
        let welcomeController = WelcomeController()
        present(welcomeController, animated: true, completion: nil)
    }
    
    private func removeAccountPressed() {
        Swift.print("Remove account pressed")
    }
}
