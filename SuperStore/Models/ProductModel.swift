//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel {
    var id: Int
    var name:String
    var image: String
    var description: String?
    var price:Double
    var location:String?

    var avg_rating: Double?
    var total_reviews_count: Int?
    var quantity: Int
    
    init(id: Int, name: String,image: String,description: String?, quantity: Int,price:Double,location:String?,avg_rating: Double?, total_reviews_count: Int?) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.quantity = quantity
        self.price = price
        self.location = location
        
        self.avg_rating = avg_rating
        self.total_reviews_count = total_reviews_count
    }
}
