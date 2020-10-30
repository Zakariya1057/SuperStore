//
//  ItemModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductItemModel {
    var name: String
    var quantity: Int = 0
    var product_id: Int
    var price: Double
    var promotion: PromotionModel?
    var weight: String? = nil
    var totalPrice: Double = 1
    var smallImage: String
    var largeImage: String
    
    var listManager: ListManager = ListManager()
    
    init(name: String, smallImage: String, largeImage: String,quantity: Int, product_id: Int, price: Double, weight: String?,promotion: PromotionModel?) {
        self.name = name
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.quantity = quantity
        self.product_id = product_id
        self.price = price
        self.weight = weight
        self.promotion = promotion
        self.totalPrice = 1
    }
}