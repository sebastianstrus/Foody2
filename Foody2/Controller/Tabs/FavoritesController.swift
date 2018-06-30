//
//  FavoritesController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var favoritesView: FavoritesView!
    private let cellId = "cellId"
    
    private var favoritesMeals: [Meal]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get data from FireBase on background thread
        Data.getMeals(complition: { (meals) in
            self.favoritesMeals = meals
            self.favoritesView.collectionView.reloadData()
        })
        
        setupNavigationBar(title: Strings.FAVORITES)
        setupView()
    }
    
    private func setupView() {
        let favoritesView = FavoritesView()
        self.favoritesView = favoritesView
        view.addSubview(favoritesView)
        favoritesView.pinToEdges(view: view)

        favoritesView.collectionView.delegate = self
        favoritesView.collectionView.dataSource = self
        favoritesView.collectionView.register(MealCell.self, forCellWithReuseIdentifier: cellId)
    }

// MARK: - UICollectionViewDataSource functions
    
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



