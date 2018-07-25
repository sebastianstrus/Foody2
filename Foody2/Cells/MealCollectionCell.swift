//
//  MealCollectionCell.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-27.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class MealCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        //temporary
        let iv = UIImageView(image: #imageLiteral(resourceName: "table"))
        self.addSubview(iv)
        iv.pinToEdges(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
