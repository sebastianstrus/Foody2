//
//  AddMealControler.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import Cosmos
import MapKit
import KVNProgress

class AddMealControler : UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate  {
    
    private var addMealView: AddMealView!
    private var meal: Meal?
    
    private var goal : MKPointAnnotation?
    private var currentMealLatitude = 0.0
    private var currentMealLongitude = 0.0
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "Add meal".localized)
        setupView()
        locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupView() {
        let mainView = AddMealView()
        addMealView = mainView
        addMealView.cameraAction = cameraPressed
        addMealView.libraryAction = libraryPressed
        addMealView.popupAction = showPopupPressed
        addMealView.saveAction = saveMealPressed
        setupMapView()
        
        view.addSubview(addMealView)
        addMealView.pinToEdges(view: view)
    }
    
    // MARK: - Events
    private func cameraPressed() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func libraryPressed() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func showPopupPressed() {
        //TODO: Create pop-up for selecting date
    }
    
    private func saveMealPressed() {
        
        let currentUser = Auth.auth().currentUser
        let userUid = currentUser?.uid
        
        let mealImageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("meals_images").child("\(mealImageName).png")
        
        KVNProgress.show(withStatus: "Saving...")
        if let uploadData = addMealView.mealImageView.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    KVNProgress.showError(withStatus: "Couldn't save new meal!".localized)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        KVNProgress.showError(withStatus: "Couldn't save new meal!".localized)
                        return
                    }
                    if let mealImageUrl = url?.absoluteString {
                        let values = ["title": self.addMealView.titleTF.text! ,
                                      "imageUrlString": mealImageUrl,
                                      "rating": self.addMealView.cosmosView.rating,
                                      "date": self.addMealView.dateLabel.text!,
                                      "isFavorite": self.addMealView.favoriteSwitch.isOn,
                                      "mealDescription": self.addMealView.mealDescriptionTV.text,
                                      "placeLatitude": self.currentMealLatitude,
                                      "placeLongitude": self.currentMealLongitude,
                                      "price": self.addMealView.priceTF.text!] as [String: AnyObject]
                        self.saveMealWith(uid: userUid!, values: values)
                    }
                })
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            addMealView.mealImageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - Map Functions
    func setupMapView() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.mapLongPressed(_:)))
        addMealView.mapView.addGestureRecognizer(tap)
        addMealView.mapView.showsUserLocation = true
    }
    
    @objc func mapLongPressed(_ sender: UILongPressGestureRecognizer) {
        if (addMealView.titleTF.text?.isEmpty)! {
            showMessage("Title text field can't be empty!".localized, withTitle: "Adding annotation".localized)
        } else {
            if sender.state == UIGestureRecognizer.State.began {
                let position = sender.location(in: addMealView.mapView)
                let coordinate = addMealView.mapView.convert(position, toCoordinateFrom: addMealView.mapView)
                currentMealLatitude = coordinate.latitude
                currentMealLongitude = coordinate.longitude
                if let existing = goal {
                    addMealView.mapView.removeAnnotation(existing)
                }
                let  annotation = MKPointAnnotation()
                annotation.title = addMealView.titleTF.text
                annotation.coordinate = coordinate
                addMealView.mapView.addAnnotation(annotation)
                goal = annotation
            }
        }
    }
    
    // MARK: - Helpers
    private func saveMealWith(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: AppURLs.FOODY_DB)
        let key = ref.child("meals").childByAutoId().key
        let childUpdates = ["/users/\(uid)/meals/\(key)/": values]
        ref.updateChildValues(childUpdates) { (error, ref) in
            if error != nil {
                debugPrint(error!)
                KVNProgress.showError(withStatus: "Couldn't save new meal!".localized)
            }
            KVNProgress.showSuccess(withStatus: "Successfully saved!", completion: {
                self.resetForm()
                self.tabBarController?.selectedIndex = 0
            })
        }
    }
    
    func resetForm() {
        addMealView.titleTF.text = ""
        addMealView.mealImageView.image = #imageLiteral(resourceName: "table")
        addMealView.mealDescriptionTV.text = "It was very tasty. :)".localized
        addMealView.priceTF.text = "100 kr".localized
        addMealView.favoriteSwitch.isOn = false
        addMealView.mapView.removeAnnotations(addMealView.mapView.annotations)
    }
    
    // MARK: - CLLocationManagerDelegate functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.addMealView.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}
