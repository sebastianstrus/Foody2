//
//  SignUpView.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "restaurant"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "image_user"))
        iv.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderWidth = Device.IS_IPHONE ? 0.5 : 1
        iv.layer.borderColor = UIColor.darkGray.cgColor
        iv.layer.cornerRadius = Device.IS_IPHONE ? 5 : 10
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    @objc func handleSelectProfileImageView() {
        selectProfileImageViewAction?()
    }
    
    let nameTF: UITextField = {
        let tf = UITextField(placeHolder: "Name".localized)
        return tf
    }()
    
    let emailTF: UITextField = {
        let tf = UITextField(placeHolder: "Email".localized)
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField(placeHolder: "Password".localized)
        return tf
    }()
    
    let confirmPasswordTF: UITextField = {
        let tf = UITextField(placeHolder: "Confirm password".localized)
        return tf
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(title: "Submit".localized, borderColor: AppColors.GREEN_BORDER)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(title: "Cancel".localized, borderColor: AppColors.RED_BORDER)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    var submitAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    var selectProfileImageViewAction: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        let stackView = createStackView(views: [nameTF, emailTF, passwordTF, confirmPasswordTF, submitButton, cancelButton])
        addSubview(backgroundImageView)
        addSubview(stackView)
        backgroundImageView.setAnchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        //set layout for stackview
        stackView.setAnchor(top: nil, leading: nil, bottom: nil, trailing: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width - (Device.IS_IPHONE ? 60 : 300), height: Device.IS_IPHONE ? 290 : 580)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: Device.IS_IPHONE ? -10 : -20).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.33).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
    }
    
    @objc func handleSubmit(){
        submitAction?()
    }
    
    @objc func handleCancel(){
        cancelAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

