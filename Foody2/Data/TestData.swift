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
            let meals = [Meal(title: "Title1", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title2", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description2", placeLatitude: 60.5, placeLongitude: 60.5, price: "10"),
                         Meal(title: "Title3", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description3", placeLatitude: 20.5, placeLongitude: 20.5, price: "20"),
                         Meal(title: "Title4", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description4", placeLatitude: 60.5, placeLongitude: 60.5, price: "30"),
                         Meal(title: "Title5", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "50"),
                         Meal(title: "Title6", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "70"),
                         Meal(title: "Title7", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title8", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "80"),
                         Meal(title: "Title9", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title10", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title11", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title12", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title13", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title14", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title15", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title16", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title17", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title18", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: true, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title19", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: false, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title20", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: false, mealDescription: "Description1", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title21", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: false, mealDescription: "Description23", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"),
                         Meal(title: "Title22", imageUrlString: "table.png", rating: 3.0, date: "10.10.2000", isFavorite: false, mealDescription: "Description22", placeLatitude: 60.5, placeLongitude: 60.5, price: "20"), ]
            sleep(2) // for testing before start using FireBase to save meals
            
            
            DispatchQueue.main.async {
                complition(meals)
            }
        }
    }
    

}
