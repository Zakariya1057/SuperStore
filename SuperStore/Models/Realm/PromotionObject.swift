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
    @objc dynamic var name: String = ""
    
    @objc dynamic var storeTypeID: Int = 0
    
    @objc dynamic var quantity: Int = 0
    
    var forQuantity = RealmOptional<Int>()
    var price = RealmOptional<Double>()
    
    var products = List<ProductObject>()
    
    @objc dynamic var startsAt: Date? = nil
    @objc dynamic var endsAt: Date? = nil
    
    @objc dynamic var expires: Bool = false
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getPromotionModel() -> PromotionModel {
        return PromotionModel(
            id: id,
            name: name,
            storeTypeID: storeTypeID,
            quantity: quantity,
            price: price.value,
            forQuantity: forQuantity.value,
            products: products.map{$0.getProductModel()},
            startsAt: startsAt,
            endsAt: endsAt
        )
    }
}

