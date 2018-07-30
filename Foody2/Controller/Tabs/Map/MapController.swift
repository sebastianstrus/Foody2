//
//  MapController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mainMapView: MapView!
    var allMeals: [Meal] = []
    var thumbnailImageByAnnotation = [NSValue : UIImage]()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "Map".localized)
        setupMapView()
        
        FirebaseHandler.getMeals(favorites: nil) { (meals) in
            self.allMeals = meals
            self.addImageAnnotations()
        }
        
        locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addImageAnnotations()
        
        FirebaseHandler.getMeals(favorites: nil) { (meals) in
            if (self.allMeals.count != meals.count) {
                self.allMeals = meals
                self.mainMapView.mapView.removeAnnotations(self.mainMapView.mapView.annotations)
                self.addImageAnnotations()
            }
        }
    }
    
    private func setupMapView() {
        let mainView = MapView()
        mainMapView = mainView
        mainView.mapView.delegate = self
        view.addSubview(mainMapView)
        mainMapView.pinToEdges(view: view)
        mainMapView.mapView.delegate = self
        mainMapView.mapView.showsUserLocation = true
    }
    
    // MARK: - CLLocationManagerDelegate functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mainMapView.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
        }
        /// Set the "pin" image of the annotation view
        annotationView?.image = getThumbnailForAnnotation(annotation: annotation)
        return annotationView
    }
    
    // MARK: - Helpers
    func getThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }
    
    func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    func addImageAnnotations() {
        for meal in (allMeals) {
            let coordinate = CLLocationCoordinate2D(latitude: meal.placeLatitude!, longitude: meal.placeLongitude!)
            let  annotation = MKPointAnnotation()
            let imageUrlString = meal.imageUrlString
            let imageUrl:URL = URL(string: imageUrlString!)!
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                DispatchQueue.main.async {
                    var image = UIImage(data: imageData as Data)
                    image = self.scaleImage(image: image!, maximumWidth: 50)
                    self.thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = image
                    annotation.title = meal.title
                    self.mapView(self.mainMapView.mapView, viewFor: annotation)?.annotation = annotation
                    annotation.coordinate = coordinate
                    self.mainMapView.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}
