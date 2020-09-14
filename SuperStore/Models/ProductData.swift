//
//  GroceryData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ProductDataResponse: Decodable {
    var data: ProductData
}

struct ProductData:Decodable {
    var id: Int
    var name:String
    var large_image: String
    var small_image: String
    var description: String?
    var price:Double
    var storage: String?
    var weight: String?
    
    var avg_rating: Double?
    var total_reviews_count: Int?
    
    var dietary_info: String?
    var allergen_info: String?
    
    var brand:String
    
    var reviews: [ReviewData]?
    var promotion: PromotionData?
    var ingredients: [IngredientsData]?
    
    var recommended: [ProductData]?
}

