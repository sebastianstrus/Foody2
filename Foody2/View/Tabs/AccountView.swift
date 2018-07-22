//
//  LoginView.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-01.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class AccountView: UIView {
    
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // views to imageContainer
    var profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "image_user"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderWidth = Device.IS_IPHONE ? 0.5 : 1
        iv.layer.borderColor = UIColor.darkGray.cgColor
        return iv
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton(title: Strings.CAMERA, color: AppColors.DODGER_BLUE)
        button.addTarget(self, action: #selector(handleCamera), for: .touchUpInside)
        return button
    }()
    
    let libraryButton: UIButton = {
        let button = UIButton(title: Strings.LIBRARY, color: AppColors.DODGER_BLUE)
        button.addTarget(self, action: #selector(handleLibrary), for: .touchUpInside)
        return button
    }()
    
    
    // views to info container
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.USERNAME_
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = Strings.EMAIL_
        return label
    }()
    
    let numberOfMealsLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.SAVED_MEALS_
        return label
    }()
    
    let registrationDateLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.REG_DATE_
        return label
    }()
    
    // buttons to buttonsContainer
    let logoutButton: UIButton = {
        let button = UIButton(title: Strings.LOG_OUT, color: AppColors.DODGER_BLUE)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        return button
    }()
    
    let removeAccountButton: UIButton = {
        let button = UIButton(title: Strings.REMOVE_ACCOUNT, color: AppColors.RED_BORDER)
        button.addTarget(self, action: #selector(handleRemoveAccount), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        [imageContainer, infoContainer, buttonsContainer].forEach({addSubview($0)})
        
        //imageContainer
        imageContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        imageContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        imageContainer.addSubview(profileImageView)
        imageContainer.addSubview(cameraButton)
        imageContainer.addSubview(libraryButton)
        
        profileImageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.7).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.7).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        
        cameraButton.setAnchor(top: profileImageView.bottomAnchor,
                                           leading: profileImageView.leadingAnchor,
                                           bottom: nil,
                                           trailing: nil,
                                           paddingTop: 5,
                                           paddingLeft: 10,
                                           paddingBottom: 0,
                                           paddingRight: 0)
        cameraButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 0.4).isActive = true
        libraryButton.setAnchor(top: profileImageView.bottomAnchor,
                                            leading: nil,
                                            bottom: nil,
                                            trailing: profileImageView.trailingAnchor,
                                            paddingTop: 5,
                                            paddingLeft: 0,
                                            paddingBottom: 0,
                                            paddingRight: 10)
        libraryButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 0.4).isActive = true
        
        //info container
        infoContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30).isActive = true
        infoContainer.topAnchor.constraint(equalTo: imageContainer.bottomAnchor).isActive = true
        
        let stackview = createStackView(views: [userNameLabel, emailLabel, numberOfMealsLabel, registrationDateLabel])
        
        infoContainer.addSubview(stackview)
        stackview.setAnchor(top: infoContainer.topAnchor,
                            leading: infoContainer.leadingAnchor,
                            bottom: infoContainer.bottomAnchor,
                            trailing: infoContainer.trailingAnchor,
                            paddingTop: 10,
                            paddingLeft: 80,
                            paddingBottom: 10,
                            paddingRight: 10)

        // two buttons container
        buttonsContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        buttonsContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: infoContainer.bottomAnchor).isActive = true
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [logoutButton, removeAccountButton])
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor.red
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        buttonsContainer.addSubview(stackView)
        stackView.setAnchor(top: nil,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: Device.IS_IPHONE ? 150 : 300,
                            height: Device.IS_IPHONE ? 70 : 140)
        stackView.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: buttonsContainer.centerXAnchor).isActive = true
        
        //        buttonsContainer.addSubview(accountView.logoutButton)
        //        buttonsContainer.addSubview(accountView.removeAccountButton)
        
        
    }
    
    
    // Actions
    var cameraAction: (() -> Void)?
    var libraryAction: (() -> Void)?
    var logoutAction: (() -> Void)?
    var removeAccountAction: (() -> Void)?
    
    @objc func handleCamera() {
        print("Camera")
        cameraAction?()
    }

    @objc func handleLibrary() {
        print("Library")
        libraryAction?()
    }
    
    @objc func handleLogOut() {
        print("Camera")
        logoutAction?()
    }
    
    @objc func handleRemoveAccount() {
        print("RemoveAccount")
        removeAccountAction?()
    }
}
