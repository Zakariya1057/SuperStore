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
    var favourite: Bool = false

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
    
    func getRealmObject() -> ProductHistory {
        let product = ProductHistory()
        product.id = self.id
        product.name = self.name
        product.image = self.image
        product.product_description = self.description
        product.quantity = self.quantity
        product.weight = self.weight
        product.price = self.price
        product.location = self.location
        product.avg_rating = self.avg_rating ?? 0
        product.total_reviews_count = self.total_reviews_count ?? 0
        product.favourite = self.favourite
        
        product.parent_category_id = self.parent_category_id ?? 0
        product.parent_category_name = self.parent_category_name
        
        product.discount = self.discount?.getRealmObject()
    
        return product
    }
}

class DiscountModel {
    var id: Int
    var name: String
    var quantity: Int
    var price: Double?
    var forQuantity: Int?
    
    init(id: Int, name: String, quantity: Int, price: Double?,forQuantity: Int? ) {
        self.quantity = quantity
        self.price = price
        self.forQuantity = forQuantity
        self.name = name
        self.id = id
    }
    
    func getRealmObject() -> DiscountHistory {
        let discount = DiscountHistory()
        discount.id = self.id
        discount.name = self.name
        discount.quantity = self.quantity
        discount.forQuantity = self.forQuantity ?? 0
        discount.price = self.price ?? 0
        
        return discount
    }
}
