//
//  ItemModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductItemModel {
    var image: String
    var name: String
    var quantity: Int = 0
    var product_id: Int
    var price: Double
    var discount: DiscountModel?
    var weight: String? = nil
    var totalPrice: Double = 1
    
    var listManager: ListManager = ListManager()
    
    init(name: String, image: String,quantity: Int, product_id: Int, price: Double, weight: String?,discount: DiscountModel?) {
        self.name = name
        self.image = image
        self.quantity = quantity
        self.product_id = product_id
        self.price = price
        self.weight = weight
        self.discount = discount
        self.totalPrice = 1
    }
}
