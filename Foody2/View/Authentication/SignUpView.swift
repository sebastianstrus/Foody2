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
    
    let nameTextField: HoshiTextField = {
        let tf = HoshiTextField(placeHolder: Strings.NAME)

        tf.borderActiveColor = .orange
        tf.borderInactiveColor = .yellow
        return tf
    }()
    
    let emailTextField: HoshiTextField = {
        let tf = HoshiTextField(placeHolder: Strings.EMAIL)
        tf.borderActiveColor = .orange
        tf.borderInactiveColor = .yellow
        return tf
    }()
    
    let passwordTextField: HoshiTextField = {
        let tf = HoshiTextField(placeHolder: Strings.PASSWORD)
        tf.borderActiveColor = .orange
        tf.borderInactiveColor = .yellow
        return tf
    }()
    
    let confirmPasswordTextField: HoshiTextField = {
        let tf = HoshiTextField(placeHolder: Strings.CONFIRM_PASSWORD)
        tf.borderActiveColor = .orange
        tf.borderInactiveColor = .yellow
        return tf
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(title: Strings.SUBMIT, borderColor: AppColors.GREEN_BORDER)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(title: Strings.CANCEL, borderColor: AppColors.RED_BORDER)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    var submitAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        let stackView = createStackView(views: [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField, submitButton, cancelButton])
        addSubview(backgroundImageView)
        addSubview(stackView)
        backgroundImageView.setAnchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        //set layout for stackview
        stackView.setAnchor(top: nil, leading: nil, bottom: nil, trailing: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width - (Device.IS_IPHONE ? 60 : 300), height: Device.IS_IPHONE ? 310 : 620)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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

