//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel {
    var id: Int
    var name: String
    var price: Double
    var promotion: PromotionModel?
    
    var smallImage: String
    var largeImage: String
    
    var description: String?

    var favourite: Bool
    var monitoring: Bool

    var quantity: Int = 0
    var avgRating: Double = 0
    var totalReviewsCount: Int = 0

    var parentCategoryId: Int?
    var parentCategoryName: String?
    var childCategoryName: String?

    var storage: String?
    var weight: String? = nil
    var brand: String

    var dietaryInfo: String?
    var allergenInfo: String?

    var reviews: [ReviewModel] = []

    var ingredients: [String] = []

    var recommended: [ProductModel] = []

    init(id: Int, name: String, smallImage: String, largeImage: String,description: String?, quantity: Int,price:Double, avgRating: Double?, totalReviewsCount: Int?, promotion: PromotionModel?, storage: String?, weight: String?,parentCategoryId: Int?, parentCategoryName: String?, childCategoryName: String?, dietaryInfo: String?, allergenInfo: String?, brand: String, reviews: [ReviewModel], favourite: Bool, monitoring: Bool, ingredients: [String], recommended: [ProductModel]) {

        self.id = id
        self.description = description
        self.favourite = favourite
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        self.monitoring = monitoring

        self.parentCategoryId = parentCategoryId
        self.parentCategoryName = parentCategoryName
        self.childCategoryName = childCategoryName

        self.quantity = quantity
        
        self.storage = storage
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        self.dietaryInfo = dietaryInfo
        self.allergenInfo = allergenInfo
        self.brand = brand
        self.reviews = reviews
        self.favourite = favourite
        self.ingredients = ingredients
        self.recommended = recommended

        self.name = name
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.price = price
        self.weight = weight
        self.promotion = promotion
    }

}

extension ProductModel: Equatable  {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
}
