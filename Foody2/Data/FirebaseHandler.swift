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
    
    static func getMeals(complition: @escaping ([Meal]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            
//            // get data for TESTING
//            var meals: [Meal] = []
//            //add data for testing
//            for i in 1...30 {
//                let meal = Meal(title: "Title\(i)",
//                    imageUrlString: "image\(i).png",
//                    rating: 3.0,
//                    date: "10.10.2000",
//                    isFavorite: true,
//                    mealDescription: "Description\(i)",
//                    placeLatitude: Double(((Float.random(in: 0 ..< 1)) - 0.5) * 140),
//                    placeLongitude: Double(((Float.random(in: 0 ..< 1)) - 0.5) * 140),
//                    price: "2\(i)")
//                meals.append(meal)
//            }
//            sleep(2) // for testing before start using FireBase to save meals

            
            
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
                        meals.append(meal)
                        print("title: \((meal.title)!) isFavorite: \((meal.isFavorite)!)")
                        print("count: \(meals.count)")
                    }
                } else {
                    print("No meals found")
                }
            }) { (error) in
                print(error.localizedDescription)
            }

            DispatchQueue.main.async {
                complition(meals)
            }
        }
    }
}
