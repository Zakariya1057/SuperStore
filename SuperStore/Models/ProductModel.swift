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
    var weight: String?
    
    var parent_category_id: Int?
    var parent_category_name: String?
    
    var discount: DiscountModel?
    
    init(id: Int, name: String,image: String,description: String?, quantity: Int, weight: String?,parent_category_id: Int?, parent_category_name: String?, price:Double,location:String?,avg_rating: Double?, total_reviews_count: Int?, discount: DiscountModel?) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.quantity = quantity
        self.weight = weight
        self.price = price
        self.location = location
        
        self.avg_rating = avg_rating
        self.total_reviews_count = total_reviews_count
        
        self.parent_category_id = parent_category_id
        self.parent_category_name = parent_category_name
        self.discount = discount
    }
}

class DiscountModel {
    var quantity: Int
    var price: Double?
    var forQuantity: Int?
    
    init(quantity: Int, price: Double?,forQuantity: Int? ) {
        self.quantity = quantity
        self.price = price
        self.forQuantity = forQuantity
    }
}
