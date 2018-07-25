//
//  MapController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit


class MapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    private var mainMapView: MapView!
    
    private var allMeals: [Meal]  = []
    
    var locationManager: CLLocationManager!
    var thumbnailImageByAnnotation = [NSValue : UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: Strings.MAP)
        setupMapView()
        setupLocationManager()
        
        //get data from FireBase on background thread
        TestData.getMeals(complition: { (meals) in
            self.allMeals = meals
            self.reloadMarkers()
        })
        
    

    }
    
    private func setupMapView() {
        let mainView = MapView()
        mainMapView = mainView
        //mainView.mapView.delegate = self
        view.addSubview(mainMapView)
        mainMapView.pinToEdges(view: view)
    }
    

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mainMapView.mapView.setRegion(lookHereRegion, animated: true)
        }
    }
    
    // MARK: - Helpers
    func addAnnotationWithThumbnailImage(thumbnail: UIImage) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(37.783333, -122.416667)
        annotation.coordinate = locationCoordinate
        
        thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = thumbnail
        mainMapView.mapView.addAnnotation(annotation)
    }
    
    func getOurThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }
    
    func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    func reloadMarkers() {
        //clear map
        mainMapView.mapView.removeAnnotations(mainMapView.mapView.annotations)
        
        //add all
        for meal in allMeals as [Meal] {
            let coordinate = CLLocationCoordinate2D(latitude: meal.placeLatitude, longitude: meal.placeLongitude)
            let  annotation = MKPointAnnotation()
            var myImage = #imageLiteral(resourceName: "table")//UIImage(named: "table.png")
            
            //scale image
            myImage = scaleImage(image: myImage, maximumWidth: 50)
            
            thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = myImage
            annotation.title = meal.title
            mapView(mainMapView.mapView, viewFor: annotation)?.annotation = annotation
            annotation.coordinate = coordinate
            mainMapView.mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - MKMapViewDelegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
        }
        /// Set the "pin" image of the annotation view
        annotationView?.image = getOurThumbnailForAnnotation(annotation: annotation)
        
        return annotationView
    }
}
