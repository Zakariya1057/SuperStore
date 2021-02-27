//
//  PromotionModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
class PromotionModel {
    var id: Int
    var name: String
    var quantity: Int
    var price: Double?
    var forQuantity: Int?
    var products:[ProductModel]
    var expires: Bool = false
    var startsAt: Date? = nil
    var endsAt: Date? = nil

    init(id: Int, name: String, quantity: Int, price: Double?,forQuantity: Int?, products: [ProductModel] = [],expires: Bool = false, startsAt: Date? = nil, endsAt: Date? = nil) {
        self.quantity = quantity
        self.price = price
        self.forQuantity = forQuantity
        self.name = name
        self.id = id
        self.products = products
        self.expires = expires
        self.startsAt = startsAt
        self.endsAt = endsAt
    }
}
