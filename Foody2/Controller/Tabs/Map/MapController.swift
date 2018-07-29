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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "Map".localized)
        setupMapView()
        
        allMeals = getMealsFromFirebase()
        
        //TODO
        perform(#selector(addImageAnnotations), with: nil, afterDelay: 1.0)
        //self.addImageAnnotations()
        
        
//        TestData.getMeals(complition: { (meals) in
//            self.allMeals = meals
//            self.addImageAnnotations()
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainMapView.mapView.removeAnnotations(mainMapView.mapView.annotations)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Swift.print("viewDidAppear run")
        print("count: \(self.allMeals.count)")
        addImageAnnotations()
    }
    
    private func setupMapView() {
        let mainView = MapView()
        mainMapView = mainView
        mainView.mapView.delegate = self
        view.addSubview(mainMapView)
        mainMapView.pinToEdges(view: view)
        mainMapView.mapView.delegate = self
    }
    
    // MARK: - CLLocationManagerDelegate functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mainMapView.mapView.setRegion(lookHereRegion, animated: true)
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
        annotationView?.image = getOurThumbnailForAnnotation(annotation: annotation)
        
        return annotationView
    }
    
    // MARK: - Helpers
    func getOurThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }
    
    func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    @objc func addImageAnnotations() {
        print("Adding annotations - count: \(self.allMeals.count)")
        for meal in (allMeals) {
            let coordinate = CLLocationCoordinate2D(latitude: meal.placeLatitude!, longitude: meal.placeLongitude!)
            let  annotation = MKPointAnnotation()
            //var myImage = UIImage(data: meal.image as! Data)!
            var myImage = UIImage(named: "chicken")!//for testing
            //scale image
            myImage = scaleImage(image: myImage, maximumWidth: 50)
            thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = myImage
            annotation.title = meal.title
            mapView(mainMapView.mapView, viewFor: annotation)?.annotation = annotation
            annotation.coordinate = coordinate
            mainMapView.mapView.addAnnotation(annotation)
        }
    }
    
    func getMealsFromFirebase() -> [Meal] {
        var meals: [Meal] = []
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("meals").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let mealsDict = snapshot.value as? NSDictionary
            print("Meals:")
            if mealsDict != nil {
                print(mealsDict!)

                for json in (mealsDict!) {
                    let mJson = json.value as! [String : AnyObject]
                    //print("mealJson: \(mealJson["title"])")
                    guard let title = mJson["title"] as? String else { return }
                    guard let imageUrlString = mJson["imageUrlString"] as? String else { return }
                    guard let rating = mJson["rating"] as? Double else { return }
                    guard let date = mJson["date"] as? String else { return }
                    guard let isFavorite = mJson["isFavorite"] as? Bool else { return }
                    guard let mealDescription = mJson["mealDescription"] as? String else { return }
                    guard let placeLatitude = mJson["placeLatitude"] as? Double else { return }
                    guard let placeLongitude = mJson["placeLongitude"] as? Double else { return }
                    guard let price = mJson["price"] as? String else { return }
                        
                    let meal = Meal(title: title,
                                    imageUrlString: imageUrlString,
                                    rating: rating,
                                    date: date,
                                    isFavorite: isFavorite,
                                    mealDescription: mealDescription,
                                    placeLatitude: placeLatitude,
                                    placeLongitude: placeLongitude,
                                    price: price)
                    self.allMeals.append(meal)
                    print("title: \(meal.title) isFavorite: \(meal.isFavorite)")
                    print("count: \(self.allMeals.count)")
                }
            } else {
                print("No meals found")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        return meals
    }
}
