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
        TestData.getMeals(complition: { (meals) in
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
        favoritesView.collectionView.register(MealCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }

// MARK: - UICollectionViewDataSource functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MealCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("screen width: \(view.frame.width)")
        print("cell width: \(view.frame.width/3 - 12)")
        let side = view.frame.width / 3 -  (Device.IS_IPHONE ? 12 : 24)
        return CGSize(width: side, height: side)
    }
    //364 maja na wszystko
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let space: CGFloat = Device.IS_IPHONE ? 8 : 16
            return UIEdgeInsets(top: space, left: space, bottom: space, right: space)//UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        
    }
    
}



