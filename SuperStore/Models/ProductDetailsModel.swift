//
//  ProductDetailsModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

//class ProductDetailsModel: ProductModel {
//    
//    var storage: String?
//    
//    var dietary_info: String?
//    var allergen_info: String?
//    
//    var brand:String = ""
//    
//    var reviews: [ReviewModel] = []
//    
//    var ingredients: [String] = []
//    
//    var recommended: [ProductModel] = []
//    
//    init(id: Int, name: String,image: String,description: String?, quantity: Int,price:Double, avgRating: Double?, totalReviewsCount: Int?, promotion: PromotionModel?, storage: String?, weight: String?,parentCategoryId: Int?, parentCategoryName: String?, dietary_info: String?, allergen_info: String?, brand: String, reviews: [ReviewModel], favourite: Bool?, monitoring: Bool?, ingredients: [String], recommended: [ProductModel]) {
//        
//        super.init(id: id, name: name, image: image, quantity: quantity, product_id: id, price: price, weight: weight, promotion: promotion, description: description, favourite: favourite, monitoring: monitoring, avgRating: avgRating, totalReviewsCount: totalReviewsCount, parentCategoryId: parentCategoryId, parentCategoryName: parentCategoryName)
//        
//        self.storage = storage
//        self.avgRating = avgRating ?? 0
//        self.totalReviewsCount = totalReviewsCount ?? 0
//        self.dietary_info = dietary_info
//        self.allergen_info = allergen_info
//        self.brand = brand
//        self.reviews = reviews
//        self.favourite = favourite
//        self.ingredients = ingredients
//        self.recommended = recommended
//    }
//    
//    override func getRealmObject() -> ProductHistory {
//        let product = super.getRealmObject()
//        let reviewsList = List<ReviewHistory>()
//        let ingredientsList = List<String>()
//        
//        self.ingredients.forEach{ ingredientsList.append($0) }
//        self.reviews.forEach { reviewsList.append($0.getRealmObject()) }
//        
//        product.recommended = List<Int>()
//        self.recommended.forEach({ product.recommended.append( $0.id ) })
//        
//        product.brand = self.brand
//        product.dietary_info = self.dietary_info
//        product.allergen_info = self.allergen_info
//        
//        product.favourite = self.favourite!
//        product.reviews = reviewsList
//        product.ingredients = ingredientsList
//        product.promotion = self.promotion?.getRealmObject()
//        
//        return product
//    }
//
//}
