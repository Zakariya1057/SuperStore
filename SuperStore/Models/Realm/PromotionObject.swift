//
//  PromotionObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//


import Foundation
import RealmSwift

class PromotionObject: Object {
    @objc dynamic var id: Int = 1
    
    @objc dynamic var title: String? = nil
    @objc dynamic var name: String = ""
    
    @objc dynamic var storeTypeID: Int = 0
    
    var quantity = RealmOptional<Int>()
    var forQuantity = RealmOptional<Int>()
    var price = RealmOptional<Double>()
    
    var minimum = RealmOptional<Int>()
    var maximum = RealmOptional<Int>()
    
    var products = List<ProductObject>()
    
    @objc dynamic var startsAt: Date? = nil
    @objc dynamic var endsAt: Date? = nil
    
    @objc dynamic var expires: Bool = false
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getPromotionModel() -> PromotionModel {
        return PromotionModel(
            id: id,
            title: title,
            name: name,
            storeTypeID: storeTypeID,
            quantity: quantity.value,
            price: price.value,
            forQuantity: forQuantity.value,
            minimum: minimum.value,
            maximum: maximum.value,
            products: products.map{$0.getProductModel()},
            expires: expires,
            startsAt: startsAt,
            endsAt: endsAt
        )
    }
    
    
    
    override static func primaryKey() -> String? {
         return "id"
     }
}

