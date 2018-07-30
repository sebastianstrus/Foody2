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
    var image100UrlString: String?
    var rating: Double?
    var date: String?
    var isFavorite: Bool?
    var mealDescription: String?
    var placeLatitude: Double?
    var placeLongitude: Double?
    var price: String?
    
    init(title: String,
         imageUrlString: String,
         image100UrlString: String,
         rating: Double,
         date: String,
         isFavorite: Bool,
         mealDescription: String,
         placeLatitude: Double,
         placeLongitude: Double,
         price: String) {
        
        self.title = title
        self.imageUrlString = imageUrlString
        self.image100UrlString = imageUrlString
        self.rating = rating
        self.date = date
        self.isFavorite = isFavorite
        self.mealDescription = mealDescription
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.price = price
    }
}

