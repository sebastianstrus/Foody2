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
//import PlaygroundSupport

class AddMealControler : UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate  {
    
    private var addMealView: AddMealView!
    private var meal: Meal?
    
    private var goal : MKPointAnnotation?
    private var currentLatitude = 0.0
    private var currentLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: Strings.ADD_MEAL)
        setupView()

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
        
    }
    
    private func saveMealPressed() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
//        let mealObject = ["title": addMealView.titleTF.text,
//                          "timestamp": [".sv":"timestamp"]
//        ] as [String: Any]
//
//        let mealRef = Database.database().reference().child("meals").childByAutoId()
//        mealRef.setValue(nil) { (error, ref) in
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            print("New meal succesfully saved!")
//        }
        
        let meal = Meal(title: addMealView.titleTF.text,
                        imageUrlString: "test/image.jpg",
                        rating: addMealView.cosmosView.rating,
                        date: addMealView.dateLabel.text,
                        isFavorite: addMealView.favoriteSwitch.isOn,
                        mealDescription: addMealView.mealDescriptionTF.text,
                        placeLatitude: currentLatitude,
                        placeLongitude: currentLongitude,
                        price: addMealView.priceTF.text)
        print("meal:")
        debugPrint(meal)
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
    }
    
    @objc func mapLongPressed(_ sender: UILongPressGestureRecognizer) {
        if (addMealView.titleTF.text?.isEmpty)! {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.showMessage("Title can't be empty!".localized, withTitle: "Adding marker")
        } else {
            if sender.state == UIGestureRecognizer.State.began {
                let position = sender.location(in: addMealView.mapView)
                let coordinate = addMealView.mapView.convert(position, toCoordinateFrom: addMealView.mapView)
                currentLatitude = coordinate.latitude
                currentLongitude = coordinate.longitude
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
}
