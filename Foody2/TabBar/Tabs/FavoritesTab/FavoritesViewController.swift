//
//  FavoritesViewController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let cellId = "cellId"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    
    private let backgroundIV: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "restaurant"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var favoritesMeals: [Meal]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get data from FireBase
        Data.getMeals(complition: { (meals) in
            self.favoritesMeals = meals
            self.collectionView.reloadData()
        })
        
        setupNavigationBar(title: "Favorites".localized)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(backgroundIV)
        view.addSubview(collectionView)
        
        backgroundIV.setAnchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        collectionView.setAnchor(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  trailing: view.trailingAnchor,
                                  paddingTop: 0,
                                  paddingLeft: 10,
                                  paddingBottom: 0,
                                  paddingRight: 10)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MealCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3 - 16, height: view.frame.width / 3 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        }
    }
    
}



