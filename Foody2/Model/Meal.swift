//
//  Meal.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-18.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import Foundation

struct Meal: Codable {
    
    var title: String?
    var imageUrlString: String?
    var rating: Double?
    var date: String?
    var isFavorite: Bool?
    var mealDescription: String?
    var placeLatitude: Double?
    var placeLongitude: Double?
    var price: String?
    
    init(title: String,
         imageUrlString: String,
         rating: Double,
         date: String,
         isFavorite: Bool,
         mealDescription: String,
         placeLatitude: Double,
         placeLongitude: Double,
         price: String) {
        
        self.title = title
        self.imageUrlString = imageUrlString
        self.rating = rating
        self.date = date
        self.isFavorite = isFavorite
        self.mealDescription = mealDescription
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.price = price
    }
    
//    init(json: [String : Any]) {
//        if let title = json["title"] as? String, let imageUrlString = json["imageUrlString"] as? String, let rating = json["rating"] as? Double, let date = json["date"] as? String, let isFavorite = json["isFavorite"] as? Bool, let mealDescription = json["mealDescription"] as? String, let placeLatitude = json["placeLatitude"] as? Double, let placeLongitude = json["placeLongitude"] as? Double, let price = json["price"] as? String {
//            
//            self.title = title
//            self.imageUrlString = imageUrlString
//            self.rating = rating
//            self.date = date
//            self.isFavorite = isFavorite
//            self.mealDescription = mealDescription
//            self.placeLatitude = placeLatitude
//            self.placeLongitude = placeLongitude
//            self.price = price
//        }
//    }
}

