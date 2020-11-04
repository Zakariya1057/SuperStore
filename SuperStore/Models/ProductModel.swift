//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductModel: ProductItemModel {
    
    var id: Int
    var description: String?

    var favourite: Bool? = nil
    var monitoring: Bool? = nil

    var avgRating: Double = 0
    var totalReviewsCount: Int = 0

    var parentCategoryId: Int?
    var parentCategoryName: String?
    var childCategoryName: String?
    
    var storage: String?
    
    var dietary_info: String?
    var allergen_info: String?
    
    var brand: String?
    
    var reviews: [ReviewModel] = []
    
    var ingredients: [String] = []
    
    var recommended: [ProductModel] = []
    
    init(id: Int, name: String, smallImage: String, largeImage: String,description: String?, quantity: Int,price:Double, avgRating: Double?, totalReviewsCount: Int?, promotion: PromotionModel?, storage: String?, weight: String?,parentCategoryId: Int?, parentCategoryName: String?, childCategoryName: String?, dietary_info: String?, allergen_info: String?, brand: String, reviews: [ReviewModel], favourite: Bool?, monitoring: Bool?, ingredients: [String], recommended: [ProductModel]) {
        
        self.id = id
        self.description = description
        self.favourite = favourite ?? false
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        self.monitoring = monitoring

        self.parentCategoryId = parentCategoryId
        self.parentCategoryName = parentCategoryName
        self.childCategoryName = childCategoryName
        
        self.storage = storage
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        self.dietary_info = dietary_info
        self.allergen_info = allergen_info
        self.brand = brand
        self.reviews = reviews
        self.favourite = favourite
        self.ingredients = ingredients
        self.recommended = recommended
        
        super.init(name: name, smallImage: smallImage,largeImage: largeImage, quantity: quantity, product_id: id, price: price, weight: weight, promotion: promotion)
    }
    
    func getRealmObject() -> ProductHistory {
        
        let product = ProductHistory()
        
        product.id = self.product_id
        product.name = self.name
        product.smallImage = self.smallImage
        product.largeImage = self.largeImage
        product.product_description = self.description
        product.quantity = self.quantity
        product.weight = self.weight
        product.price = self.price
        product.avgRating = self.avgRating
        product.totalReviewsCount = self.totalReviewsCount
        product.favourite = self.favourite ?? false
        product.monitoring = self.monitoring ?? false

        product.parentCategoryId = self.parentCategoryId ?? 0
        product.parentCategoryName = self.parentCategoryName
        product.childCategoryName = self.childCategoryName

        product.promotion = self.promotion?.getRealmObject()
        
        let reviewsList = List<ReviewHistory>()
        let ingredientsList = List<String>()
        
        self.ingredients.forEach{ ingredientsList.append($0) }
        self.reviews.forEach { reviewsList.append($0.getRealmObject()) }
        
        product.recommended = List<Int>()
        self.recommended.forEach({ product.recommended.append( $0.id ) })
        
        product.brand = self.brand ?? ""
        product.dietary_info = self.dietary_info
        product.allergen_info = self.allergen_info
        
        product.reviews = reviewsList
        product.ingredients = ingredientsList
        product.promotion = self.promotion?.getRealmObject()
        
        return product
    }
    
}
