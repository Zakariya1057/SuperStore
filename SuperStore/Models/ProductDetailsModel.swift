//
//  ProductDetailsModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductDetailsModel: ProductModel {
    
    var storage: String?
    
    var dietary_info: String?
    var allergen_info: String?
    
    var brand:String = ""
    
    var reviews: [ReviewModel] = []
    var promotion: PromotionModel?
    
    var ingredients: [String] = []
    
    var recommended: [ProductModel] = []
    var favourite: Bool = false
    
    init(id: Int, name: String,image: String,description: String?, quantiy: Int,price:Double,location:String?, avg_rating: Double?, total_reviews_count: Int?, storage: String?, weight: String?,parent_category_id: Int?, parent_category_name: String?, dietary_info: String?, allergen_info: String?, brand: String, reviews: [ReviewModel], favourite: Bool, promotion: PromotionModel?, ingredients: [String], recommended: [ProductModel]) {
        
        super.init(id: id, name: name, image: image, description: description, quantity: quantiy, weight: weight,parent_category_id: parent_category_id, parent_category_name: parent_category_name, price:price, location: location,avg_rating: avg_rating, total_reviews_count: total_reviews_count, discount: nil)
        self.storage = storage
        self.avg_rating = avg_rating
        self.total_reviews_count = total_reviews_count
        self.dietary_info = dietary_info
        self.allergen_info = allergen_info
        self.brand = brand
        self.reviews = reviews
        self.favourite = favourite
        self.promotion = promotion
        self.ingredients = ingredients
        self.recommended = recommended
    }

}
