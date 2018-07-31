//
//  Data.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-24.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase

class FirebaseHandler {
    
    static func getMeals(favorites: Bool?, complition: @escaping ([Meal]) -> ()) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("meals").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let mealsDict = snapshot.value as? NSDictionary
            var meals: [Meal] = []
            
            if mealsDict != nil {
                for json in (mealsDict!) {
                    let mJson = json.value as! [String : AnyObject]
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
                    if let aFavorites = favorites, aFavorites == true {
                        if meal.isFavorite! {
                            meals.append(meal)
                        }
                    } else {
                        print("append meal")
                        meals.append(meal)
                    }
                }
            } else {
                print("No meals found")
            }
            complition(meals)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
