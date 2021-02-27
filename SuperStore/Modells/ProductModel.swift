//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel {

    var name: String
    var quantity: Int = 0
    var productID: Int
    var price: Double
    var promotion: PromotionModel?
    var weight: String? = nil
    var totalPrice: Double = 1
    var smallImage: String
    var largeImage: String
    
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

    var dietaryInfo: String?
    var allergenInfo: String?

    var brand: String?

    var reviews: [ReviewModel] = []

    var ingredients: [String] = []

    var recommended: [ProductModel] = []

    init(id: Int, name: String, smallImage: String, largeImage: String,description: String?, quantity: Int,price:Double, avgRating: Double?, totalReviewsCount: Int?, promotion: PromotionModel?, storage: String?, weight: String?,parentCategoryId: Int?, parentCategoryName: String?, childCategoryName: String?, dietaryInfo: String?, allergenInfo: String?, brand: String, reviews: [ReviewModel], favourite: Bool?, monitoring: Bool?, ingredients: [String], recommended: [ProductModel]) {

        self.id = id
        self.productID = id
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
        self.quantity = quantity
        self.price = price
        self.weight = weight
        self.promotion = promotion
        self.totalPrice = 1
    }

}
