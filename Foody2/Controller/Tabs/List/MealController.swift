//
//  MealController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-07-25.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Foundation
import Cosmos
import MapKit

class MealController : UIViewController  {
    
    
    var meal: Meal?
    
    private var mealView: MealView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "Meal")
        setupView()
        
    }
    
    func setupView() {
        let mainView = MealView()
        mealView = mainView

        setupMapView()
        
        view.addSubview(mealView)
        mealView.pinToEdges(view: view)
        
        mealView.titleLabel.text = meal?.title
        mealView.mealImageView.load(urlString: (meal?.imageUrlString)!)
        mealView.cosmosView.rating = (meal?.rating)!
        mealView.dateLabel.text = "Date: ".localized + Date().formatedString()//temp//meal?.date
        
        mealView.priceLabel.text = "Price: ".localized + "\(meal?.price ?? "0") kr"
        mealView.mealDescriptionTF.text = meal?.mealDescription
        let coordinate = CLLocationCoordinate2D(latitude: (meal?.placeLatitude)!, longitude: (meal?.placeLongitude)!)
        let  annotation = MKPointAnnotation()
        annotation.title = meal?.title
        annotation.coordinate = coordinate
        mealView.mapView.addAnnotation(annotation)
        
    }
    
    func setupMapView() {
        
    }
}
