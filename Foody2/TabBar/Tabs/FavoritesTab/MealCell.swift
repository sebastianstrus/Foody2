//
//  MealCell.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-27.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class MealCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
