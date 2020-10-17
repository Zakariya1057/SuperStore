//
//  ProductDetailsModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductDetailsModel: ProductModel {
    
    var storage: String?
    
    var dietary_info: String?
    var allergen_info: String?
    
    var brand:String = ""
    
    var reviews: [ReviewModel] = []
    
    var ingredients: [String] = []
    
    var recommended: [ProductModel] = []
    
    init(id: Int, name: String,image: String,description: String?, quantity: Int,price:Double, avg_rating: Double?, total_reviews_count: Int?, discount: DiscountModel?, storage: String?, weight: String?,parent_category_id: Int?, parent_category_name: String?, dietary_info: String?, allergen_info: String?, brand: String, reviews: [ReviewModel], favourite: Bool?, ingredients: [String], recommended: [ProductModel]) {
        
        super.init(id: id, name: name, image: image, quantity: quantity, product_id: id, price: price, weight: weight, discount: discount, description: description, favourite: favourite, avg_rating: avg_rating, total_reviews_count: total_reviews_count, parent_category_id: parent_category_id, parent_category_name: parent_category_name)
        
        self.storage = storage
        self.avg_rating = avg_rating ?? 0
        self.total_reviews_count = total_reviews_count ?? 0
        self.dietary_info = dietary_info
        self.allergen_info = allergen_info
        self.brand = brand
        self.reviews = reviews
        self.favourite = favourite
        self.ingredients = ingredients
        self.recommended = recommended
    }
    
    override func getRealmObject() -> ProductHistory {
        let product = super.getRealmObject()
        let recommendedProducts = List<ProductHistory>()
        let reviewsList = List<ReviewHistory>()
        let ingredientsList = List<String>()
        
        self.ingredients.forEach{ ingredientsList.append($0) }
        self.recommended.forEach { recommendedProducts.append($0.getRealmObject()) }
        self.reviews.forEach { reviewsList.append($0.getRealmObject()) }

        product.brand = self.brand
        product.dietary_info = self.dietary_info
        product.allergen_info = self.allergen_info
        
        product.favourite = self.favourite!
        product.reviews = reviewsList
        product.recommended = recommendedProducts
        product.ingredients = ingredientsList
        
        return product
    }

}
