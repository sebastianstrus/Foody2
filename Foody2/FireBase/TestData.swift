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
            
            //get data from FireBase
            let meals = [Meal(image: "1", title: "Title1", rating: 1.0),
                         Meal(image: "2", title: "Title2", rating: 3.0),
                         Meal(image: "3", title: "Title3", rating: 10.0),
                         Meal(image: "4", title: "Title4", rating: 8.0),
                         Meal(image: "5", title: "Title5", rating: 2.0),
                         Meal(image: "1", title: "Title1", rating: 1.0),
                         Meal(image: "2", title: "Title2", rating: 3.0),
                         Meal(image: "3", title: "Title3", rating: 10.0),
                         Meal(image: "4", title: "Title4", rating: 8.0),
                         Meal(image: "5", title: "Title5", rating: 2.0),
                         Meal(image: "1", title: "Title1", rating: 1.0),
                         Meal(image: "2", title: "Title2", rating: 3.0),
                         Meal(image: "3", title: "Title3", rating: 10.0),
                         Meal(image: "4", title: "Title4", rating: 8.0),
                         Meal(image: "5", title: "Title5", rating: 2.0),
                         Meal(image: "1", title: "Title1", rating: 1.0),
                         Meal(image: "2", title: "Title2", rating: 3.0),
                         Meal(image: "3", title: "Title3", rating: 10.0),
                         Meal(image: "4", title: "Title4", rating: 8.0),
                         Meal(image: "5", title: "Title5", rating: 2.0),
                         Meal(image: "1", title: "Title1", rating: 1.0),
                         Meal(image: "2", title: "Title2", rating: 3.0),
                         Meal(image: "3", title: "Title3", rating: 10.0),
                         Meal(image: "4", title: "Title4", rating: 8.0),
                         Meal(image: "5", title: "Title5", rating: 2.0),
                         Meal(image: "1", title: "Title1", rating: 1.0),
                         Meal(image: "2", title: "Title2", rating: 3.0),
                         Meal(image: "3", title: "Title3", rating: 10.0),
                         Meal(image: "4", title: "Title4", rating: 8.0)]
            sleep(2)//for testing before using FireBase
            
            
            DispatchQueue.main.async {
                complition(meals)
            }
        }
    }
    

}
