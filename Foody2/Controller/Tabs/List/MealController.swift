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

class MealController : UIViewController, CLLocationManagerDelegate  {
    
    private var mealView: MealView!
    
    var meal: Meal?
    var locationManager: CLLocationManager!
    var coordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        setupNavigationBar(title: "Meal".localized)
        setupView()
        
        mealView.mapView.showsUserLocation = true
    }
    
    func setupView() {
        let mainView = MealView()
        mealView = mainView
        
        view.addSubview(mealView)
        mealView.pinToEdges(view: view)
        mealView.titleLabel.text = meal?.title
        mealView.mealImageView.load(urlString: (meal?.imageUrlString)!)
        mealView.cosmosView.rating = (meal?.rating)!
        mealView.dateLabel.text = "Date: ".localized + Date().formatedString()//temp//meal?.date
        mealView.priceLabel.text = "Price: ".localized + "\(meal?.price ?? "0") kr"
        mealView.mealDescriptionTF.text = meal?.mealDescription
        coordinate = CLLocationCoordinate2D(latitude: (meal?.placeLatitude)!, longitude: (meal?.placeLongitude)!)
        let  annotation = MKPointAnnotation()
        annotation.title = meal?.title
        annotation.coordinate = coordinate!
        mealView.mapView.addAnnotation(annotation)
    }
    
    // MARK: - CLLocationManagerDelegate functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil{
            let region = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mealView.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}
