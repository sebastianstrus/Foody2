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
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = AppFonts.LIST_CELL_FONT
        return label
    }()
    
    let mealImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let cosmosView: CosmosView = {
        let cv = CosmosView()
        cv.settings.updateOnTouch = false
        cv.settings.fillMode = .half
        cv.settings.starSize = 40
        cv.settings.starMargin = 10
        cv.settings.filledColor = UIColor.orange
        cv.settings.emptyBorderColor = UIColor.orange
        cv.settings.filledBorderColor = UIColor.orange
        cv.backgroundColor = .white
        return cv
    }()
    
//    private let selectDateButton: UIButton = {
//        let button = UIButton(title: "Date".localized, color: AppColors.DODGER_BLUE)
//        return button
//    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        //set current Date as default
        label.text = "Date: ".localized + Date().formatedString()//temp
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.text = "Price: 100 kr"//temp
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.text = "Description:".localized
        return label
    }()
    
    let mealDescriptionTF: UITextView = {
        let tf = UITextView()
        tf.isUserInteractionEnabled = false
        tf.textColor = UIColor.darkGray
        tf.text = "It was very tasty. :)".localized
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
        let button = UIButton(title: "Save meal".localized, color: AppColors.DODGER_BLUE)
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
        [titleLabel, mealImageView, cosmosView, dateLabel, priceLabel, mealDescriptionTF, descriptionLabel, mapView].forEach({scrollView.addSubview($0)})
        
        //title textField
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Device.IS_IPHONE ? 40 : 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        //image
        mealImageView.setAnchor(top: titleLabel.bottomAnchor,
                                leading: nil,
                                bottom: nil,
                                trailing: nil,
                                paddingTop: 20,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0)
        mealImageView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        mealImageView.heightAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        mealImageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true

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
        dateLabel.setAnchor(top: cosmosView.bottomAnchor,
                            leading: mealImageView.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            paddingTop: Device.IS_IPHONE ? 10 : 20,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: Device.IS_IPHONE ? 160 : 320,
                            height: Device.IS_IPHONE ? 32 : 64)
        
        priceLabel.setAnchor(top: nil, leading: nil, bottom: nil, trailing: mealImageView.trailingAnchor, paddingTop: Device.IS_IPHONE ? 10 : 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 140 : 280, height: Device.IS_IPHONE ? 32 : 64)
        priceLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        
        descriptionLabel.setAnchor(top: dateLabel.bottomAnchor, leading: dateLabel.leadingAnchor, bottom: nil, trailing: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Device.IS_IPHONE ? 160 : 200, height: Device.IS_IPHONE ? 32 : 64)

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

