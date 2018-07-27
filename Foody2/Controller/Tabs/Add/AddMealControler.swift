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
        
        let currentUser = Auth.auth().currentUser
        let userUid = currentUser?.uid
        
        let meal = Meal(title: addMealView.titleTF.text!,
                        imageUrlString: "test/image.jpg",
                        rating: addMealView.cosmosView.rating,
                        date: addMealView.dateLabel.text!,
                        isFavorite: addMealView.favoriteSwitch.isOn,
                        mealDescription: addMealView.mealDescriptionTF.text,
                        placeLatitude: currentLatitude,
                        placeLongitude: currentLongitude,
                        price: addMealView.priceTF.text!)
        print("eal:")
        debugPrint(meal)
        
        let mealImageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("meals_images").child("\(mealImageName).png")
        
        if let uploadData = addMealView.mealImageView.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let mealImageUrl = url?.absoluteString {
                        let values = ["title": self.addMealView.titleTF.text! ,
                                      "imageUrlString": mealImageUrl,
                                      "rating": self.addMealView.cosmosView.rating,
                                      "date": self.addMealView.dateLabel.text!,
                                      "isFavorite": self.addMealView.favoriteSwitch.isOn,
                                      "mealDescription": self.addMealView.mealDescriptionTF.text,
                                      "placeLatitude": self.currentLatitude,
                                      "placeLongitude": self.currentLongitude,
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
    
    // MARK: - Helpers
    private func saveMealWith(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://foody-4454f.firebaseio.com/")
        let key = ref.child("meals").childByAutoId().key
        let childUpdates = ["/users/\(uid)/meals/\(key)/": values]
        ref.updateChildValues(childUpdates) { (error, ref) in
            if error != nil {
                debugPrint(error!)
            }
            self.showMessage("New meal has been saved into Firebase!", withTitle: "New meal")
        }
    }
}
