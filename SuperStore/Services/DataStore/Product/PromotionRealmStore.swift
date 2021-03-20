//
//  PromotionRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class PromotionRealmStore: DataStore, PromotionStoreProtocol {
    private lazy var productStore: ProductStoreProtocol = ProductRealmStore()
    
    private func getPromotionObject(promotionID: Int) -> PromotionObject? {
        return realm?.objects(PromotionObject.self).filter("id = %@", promotionID).first
    }
    
    func createPromotion(promotion: PromotionModel) {
        if let savedPromotion = getPromotionObject(promotionID: promotion.id){
            updatePromotion(promotion: promotion, savedPromotion: savedPromotion)
        } else {
            try? realm?.write({
                let savedPromotion = createPromotionObject(promotion: promotion)
                realm?.add(savedPromotion)
            })
        }
    }
    
    func getPromotion(promotionID: Int) -> PromotionModel? {
        getPromotionObject(promotionID: promotionID)?.getPromotionModel()
    }
}


extension PromotionRealmStore {
    func updatePromotion(promotion: PromotionModel, savedPromotion: PromotionObject){
        try? realm?.write({
            
            savedPromotion.name = promotion.name
            savedPromotion.storeTypeID = promotion.storeTypeID
            
            let forQuantity = RealmOptional<Int>()
            let price = RealmOptional<Double>()
            
            forQuantity.value = promotion.forQuantity
            price.value = promotion.price

            savedPromotion.price = price
            savedPromotion.forQuantity = forQuantity
            savedPromotion.quantity = promotion.quantity
            
            savedPromotion.startsAt = promotion.startsAt
            savedPromotion.endsAt = promotion.endsAt
            savedPromotion.expires = promotion.expires
            
            savedPromotion.products.removeAll()
            
            for savedProduct in promotion.products.map({ productStore.createProductObject(product: $0) }){
                savedPromotion.products.append(savedProduct)
            }
            
            savedPromotion.updatedAt = Date()
        })
    }
}

extension PromotionRealmStore {
    func createPromotionObject(promotion: PromotionModel) -> PromotionObject {
        
        if let savedPromotion = getPromotionObject(promotionID: promotion.id){
            return savedPromotion
        }
        
        let savedPromotion = PromotionObject()
        
        savedPromotion.id = promotion.id
        savedPromotion.name = promotion.name
        savedPromotion.storeTypeID = promotion.storeTypeID
        
        let forQuantity = RealmOptional<Int>()
        let price = RealmOptional<Double>()
        
        forQuantity.value = promotion.forQuantity
        price.value = promotion.price
        
        savedPromotion.price = price
        savedPromotion.forQuantity = forQuantity
        savedPromotion.quantity = promotion.quantity
        
        savedPromotion.startsAt = promotion.startsAt
        savedPromotion.endsAt = promotion.endsAt
        savedPromotion.expires = promotion.expires
        
        for savedProduct in promotion.products.map({ productStore.createProductObject(product: $0) }) {
            savedPromotion.products.append(savedProduct)
        }
        
        return savedPromotion
    }
}
