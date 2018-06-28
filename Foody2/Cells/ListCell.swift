//
//  ListCell.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-18.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Cosmos

class ListCell: UITableViewCell {
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setCellShadow()
        return view
    }()
    
    private let pictureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "table"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = AppFonts.LIST_CELL_FONT
        return label
    }()
    
    private let cosmosView: CosmosView = {
        let cv = CosmosView()
        cv.settings.updateOnTouch = false
        cv.settings.fillMode = .half
        cv.settings.starSize = Device.IS_IPHONE ? 30 : 60
        cv.settings.starMargin = Device.IS_IPHONE ? 5 : 10
        cv.settings.filledColor = UIColor.orange
        cv.settings.emptyBorderColor = UIColor.orange
        cv.settings.filledBorderColor = UIColor.orange
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        backgroundColor = AppColors.SILVER_GREY
        addSubview(cellView)
        cellView.addSubview(pictureImageView)
       
        let stackView = UIStackView(arrangedSubviews: [titleLabel, cosmosView])
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor.blue
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        cellView.addSubview(stackView)
        
        
        cellView.setAnchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           paddingTop: 4,
                           paddingLeft: 8,
                           paddingBottom: 4,
                           paddingRight: 8)
        
        pictureImageView.setAnchor(top: nil,
                                   leading: cellView.leadingAnchor,
                                   bottom: nil,
                                   trailing: nil,
                                   paddingTop: 5,
                                   paddingLeft: 5,
                                   paddingBottom: 5,
                                   paddingRight: 5,
                                   width: Device.IS_IPHONE ? 60 : 120,
                                   height: Device.IS_IPHONE ? 60 : 120)
        pictureImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true

        stackView.setAnchor(top: nil,
                            leading: cellView.leadingAnchor,
                            bottom: nil,
                            trailing: cellView.trailingAnchor,
                            paddingTop: 0,
                            paddingLeft: Device.IS_IPHONE ? 84 : 150,
                            paddingBottom: 0,
                            paddingRight: 5,
                            width: 0,
                            height: Device.IS_IPHONE ? 60 : 120)
        stackView.centerYAnchor.constraint(equalTo: pictureImageView.centerYAnchor).isActive = true
        
        
        titleLabel.setAnchor(top: nil,
                             leading: stackView.leadingAnchor,
                             bottom: nil,
                             trailing: stackView.trailingAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: Device.IS_IPHONE ? 28 : 58)
        
        cosmosView.setAnchor(top: nil,
                             leading: stackView.leadingAnchor,
                             bottom: nil,
                             trailing: stackView.trailingAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: Device.IS_IPHONE ? 28 : 58)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
