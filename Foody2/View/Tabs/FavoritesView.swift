//
//  FavoritesView.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-28.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//


import UIKit

class FavoritesView: UIView {
    
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    
    let backgroundIV: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "restaurant"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        addSubview(backgroundIV)
        backgroundIV.pinToEdges(view: self)
        addSubview(collectionView)
        collectionView.pinToEdges(view: self)
    }
    
    
}
