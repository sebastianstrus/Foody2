//
//  MealView.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-07-25.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Cosmos
import MapKit

class MealView: UIView {
    
    
    
    // scroll view
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag;
        sv.backgroundColor = .white
        //sv.contentSize.height = 2000 // automatically
        return sv
    }()
    
    // all views in the scrollView
    let titleTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = Strings.ENTER_TITLE
        tf.backgroundColor = .white
        tf.setLeftPaddiingPoints(Device.IS_IPHONE ? 20 : 40)
        return tf
    }()
    
    let mealImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(title: Strings.CAMERA, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    private let libraryButton: UIButton = {
        let button = UIButton(title: Strings.LIBRARY, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    
    let cosmosView: CosmosView = {
        let cv = CosmosView()
        cv.settings.updateOnTouch = true
        cv.settings.fillMode = .half
        cv.settings.starSize = 40
        cv.settings.starMargin = 10
        cv.settings.filledColor = UIColor.orange
        cv.settings.emptyBorderColor = UIColor.orange
        cv.settings.filledBorderColor = UIColor.orange
        cv.backgroundColor = .white
        return cv
    }()
    
    private let selectDateButton: UIButton = {
        let button = UIButton(title: Strings.DATE, color: AppColors.DODGER_BLUE)
        return button
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        //set current Date as default
        let date = Date()//just for now
        label.text = date.formatedString()
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.PRICE_
        label.textAlignment = .right
        return label
    }()
    
    let priceTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = Strings.SEK
        tf.keyboardType = UIKeyboardType.numberPad
        tf.setLeftPaddiingPoints(Device.IS_IPHONE ? 10 : 20)
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.ADD_DESCRIPTION_
        return label
    }()
    
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.FAVORITE_
        return label
    }()
    
    let favoriteSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    let mealDescriptionTF: UITextView = {
        let tf = UITextView()
        tf.text = Strings.VERY_TASTY
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.layer.borderWidth = 1
        mv.layer.cornerRadius = 5
        mv.layer.borderColor = UIColor.lightGray.cgColor
        return mv
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(title: Strings.SAVE_MEAL, color: AppColors.DODGER_BLUE)
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
        setupScrollView()
        setupViews()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.setAnchor(top: safeTopAnchor,
                             leading: safeLeadingAnchor,
                             bottom: safeBottomAnchor,
                             trailing: safeTrailingAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0)
    }
    
    private func setupViews() {
        [titleTF, mealImageView, cosmosView, selectDateButton, dateLabel, priceLabel, priceTF, mealDescriptionTF, descriptionLabel, /*favoriteLabel, favoriteSwitch, */mapView/*, saveButton*/].forEach({scrollView.addSubview($0)})
        
        //title textField
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        titleTF.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        titleTF.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        titleTF.heightAnchor.constraint(equalToConstant: Device.IS_IPHONE ? 40 : 80).isActive = true
        titleTF.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleTF.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        //image
        mealImageView.setAnchor(top: titleTF.bottomAnchor,
                                leading: nil,
                                bottom: nil,
                                trailing: nil,
                                paddingTop: 20,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0)
        mealImageView.widthAnchor.constraint(equalTo: titleTF.widthAnchor).isActive = true
        mealImageView.heightAnchor.constraint(equalTo: titleTF.widthAnchor).isActive = true
        mealImageView.centerXAnchor.constraint(equalTo: titleTF.centerXAnchor).isActive = true
        //mealImageView.alpha = 0.4
        

        //cosmos view
        cosmosView.setAnchor(top: mealImageView.bottomAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: nil,
                             paddingTop: 10,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
        cosmosView.centerXAnchor.constraint(equalTo: mealImageView.centerXAnchor).isActive = true
        
        //date info
        selectDateButton.setAnchor(top: cosmosView.bottomAnchor,
                                   leading: mealImageView.leadingAnchor,
                                   bottom: nil,
                                   trailing: nil,
                                   paddingTop: Device.IS_IPHONE ? 10 : 20,
                                   paddingLeft: 0,
                                   paddingBottom: 0,
                                   paddingRight: 0,
                                   width: Device.IS_IPHONE ? 60 : 120,
                                   height: Device.IS_IPHONE ? 32 : 64)
        dateLabel.setAnchor(top: nil,
                            leading: selectDateButton.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            paddingTop: Device.IS_IPHONE ? 10 : 20,
                            paddingLeft: Device.IS_IPHONE ? 10 : 20,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: Device.IS_IPHONE ? 100 : 200,
                            height: Device.IS_IPHONE ? 32 : 64)
        dateLabel.centerYAnchor.constraint(equalTo: selectDateButton.centerYAnchor).isActive = true
        
        
        priceTF.setAnchor(top: nil, leading: nil, bottom: nil, trailing: mealImageView.trailingAnchor, paddingTop: Device.IS_IPHONE ? 10 : 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 70 : 140, height: Device.IS_IPHONE ? 32 : 64)
        priceTF.centerYAnchor.constraint(equalTo: selectDateButton.centerYAnchor).isActive = true
        
        priceLabel.setAnchor(top: nil, leading: nil, bottom: nil, trailing: priceTF.leadingAnchor, paddingTop: Device.IS_IPHONE ? 10 : 20, paddingLeft: 0, paddingBottom: 0, paddingRight: Device.IS_IPHONE ? 10 : 20, width: Device.IS_IPHONE ? 70 : 140, height: Device.IS_IPHONE ? 32 : 64)
        priceLabel.centerYAnchor.constraint(equalTo: selectDateButton.centerYAnchor).isActive = true
        
        
        descriptionLabel.setAnchor(top: selectDateButton.bottomAnchor, leading: selectDateButton.leadingAnchor, bottom: nil, trailing: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 160 : 200, height: Device.IS_IPHONE ? 32 : 64)
//        favoriteSwitch.setAnchor(top: selectDateButton.bottomAnchor, leading: nil, bottom: nil, trailing: mealImageView.trailingAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 50 : 100, height: Device.IS_IPHONE ? 32 : 64)
//        favoriteLabel.setAnchor(top: selectDateButton.bottomAnchor, leading: nil, bottom: nil, trailing: favoriteSwitch.leadingAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: Device.IS_IPHONE ? 32 : 64)
        
        //description field
        mealDescriptionTF.setAnchor(top: descriptionLabel.bottomAnchor,
                                    leading: mealImageView.leadingAnchor,
                                    bottom: nil,
                                    trailing: mealImageView.trailingAnchor,
                                    paddingTop: Device.IS_IPHONE ? 10 : 20,
                                    paddingLeft: 0,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 0,
                                    height: Device.IS_IPHONE ? 70 : 100)
        
        mapView.setAnchor(top: mealDescriptionTF.bottomAnchor,
                          leading: mealDescriptionTF.leadingAnchor,
                          bottom: scrollView.bottomAnchor,
                          trailing: mealDescriptionTF.trailingAnchor,
                          paddingTop: Device.IS_IPHONE ? 10 : 20,
                          paddingLeft: 0,
                          paddingBottom: Device.IS_IPHONE ? 10 : 20,
                          paddingRight: 0,
                          width: 0,
                          height: CGFloat(Device.SCREEN_WIDTH * 2 / 3))
    }
}

