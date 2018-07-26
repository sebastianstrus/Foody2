//
//  Data.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-24.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class TestData {
    
    static func getMeals(complition: @escaping ([Meal]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            //get data
            var meals: [Meal] = []
            
            //add data for testing
            for i in 1...30 {
                let meal = Meal(title: "Title\(i)",
                    imageUrlString: "image\(i).png",
                    rating: 3.0,
                    date: "10.10.2000",
                    isFavorite: true,
                    mealDescription: "Description\(i)",
                    placeLatitude: Double(((Float.random(in: 0 ..< 1)) - 0.5) * 140),
                    placeLongitude: Double(((Float.random(in: 0 ..< 1)) - 0.5) * 140),
                    price: "2\(i)")
                meals.append(meal)
            }
            sleep(2) // for testing before start using FireBase to save meals
            
            
            DispatchQueue.main.async {
                complition(meals)
            }
        }
    }
    

}
