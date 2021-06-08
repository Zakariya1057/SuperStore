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
    
    var title: String?
    var name: String
    
    var quantity: Int?
    var price: Double?
    var forQuantity: Int?
    
    var minimum: Int?
    var maximum: Int?
    
    var products:[ProductModel]
    var storeTypeID: Int
    
    var expires: Bool = false
    var startsAt: Date? = nil
    var endsAt: Date? = nil

    init(
        id: Int,
        title: String?,
        name: String,
        storeTypeID: Int,
        quantity: Int?,
        price: Double?,
        forQuantity: Int?,
        minimum: Int?,
        maximum: Int?,
        products: [ProductModel] = [],
        expires: Bool = false,
        startsAt: Date? = nil,
        endsAt: Date? = nil
    ) {
        self.id = id
        
        self.title = title
        self.name = name
        
        self.quantity = quantity
        self.price = price
        self.forQuantity = forQuantity
        
        self.minimum = minimum
        self.maximum = maximum
        
        self.storeTypeID = storeTypeID

        self.products = products
        
        self.expires = expires
        self.startsAt = startsAt
        self.endsAt = endsAt
    }
}
