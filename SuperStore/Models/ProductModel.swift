//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel: ProductItemModel {
    var id: Int
    var description: String?
    var favourite: Bool? = nil

    var avgRating: Double = 0
    var totalReviewsCount: Int = 0

    var parentCategoryId: Int?
    var parentCategoryName: String?

    init(id: Int, name: String, image: String, quantity: Int, product_id: Int, price: Double, weight: String?, promotion: PromotionModel?, description: String?, favourite: Bool?, avgRating: Double?, totalReviewsCount: Int?, parentCategoryId: Int?, parentCategoryName: String?) {
        self.id = id
        self.description = description
        self.favourite = favourite ?? false
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        
        self.parentCategoryId = parentCategoryId
        self.parentCategoryName = parentCategoryName
        
        super.init(name: name, image: image, quantity: quantity, product_id: product_id, price: price, weight: weight, promotion: promotion)
    }
    
    func getRealmObject() -> ProductHistory {
        let product = ProductHistory()
        product.id = self.product_id
        product.name = self.name
        product.image = self.image
        product.product_description = self.description
        product.quantity = self.quantity
        product.weight = self.weight
        product.price = self.price
        product.avgRating = self.avgRating
        product.totalReviewsCount = self.totalReviewsCount
        product.favourite = self.favourite!

        product.parentCategoryId = self.parentCategoryId ?? 0
        product.parentCategoryName = self.parentCategoryName

        product.promotion = self.promotion?.getRealmObject()

        return product
    }
}
