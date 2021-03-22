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
    
    func deletePromotion(promotionID: Int){
        if let savedPromotion = getPromotionObject(promotionID: promotionID){
            if let inWrite = realm?.isInWriteTransaction, inWrite {
                realm?.delete(savedPromotion)
            } else {
                try? realm?.write({
                    realm?.delete(savedPromotion)
                })
            }
        }
    }
}

extension PromotionRealmStore {
    func promotionExpired(promotion: PromotionModel) -> Bool {
        var expired: Bool = false
        
        if let endsAt = promotion.endsAt, ( endsAt < Date() && !Calendar.current.isDate(Date(), inSameDayAs: endsAt) ) {
           expired = true
        }
        
        return expired
    }
}

extension PromotionRealmStore {
    func updatePromotion(promotion: PromotionModel, savedPromotion: PromotionObject){
        try? realm?.write({
            
            savedPromotion.name = promotion.name
            savedPromotion.storeTypeID = promotion.storeTypeID
            
            let quantity = RealmOptional<Int>()
            let forQuantity = RealmOptional<Int>()
            let price = RealmOptional<Double>()
            
            quantity.value = promotion.quantity
            forQuantity.value = promotion.forQuantity
            price.value = promotion.price

            savedPromotion.price = price
            savedPromotion.forQuantity = forQuantity
            savedPromotion.quantity = quantity
            
            let minumum = RealmOptional<Int>()
            let maximum = RealmOptional<Int>()
            
            minumum.value = promotion.minimum
            maximum.value = promotion.maximum
            
            savedPromotion.minimum = minumum
            savedPromotion.maximum = maximum
            
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
        
        let quantity = RealmOptional<Int>()
        let forQuantity = RealmOptional<Int>()
        let price = RealmOptional<Double>()
        
        quantity.value = promotion.quantity
        forQuantity.value = promotion.forQuantity
        price.value = promotion.price
        
        let minumum = RealmOptional<Int>()
        let maximum = RealmOptional<Int>()
        
        minumum.value = promotion.minimum
        maximum.value = promotion.maximum
        
        savedPromotion.price = price
        savedPromotion.forQuantity = forQuantity
        savedPromotion.quantity = quantity
        
        savedPromotion.minimum = minumum
        savedPromotion.maximum = maximum
        
        savedPromotion.startsAt = promotion.startsAt
        savedPromotion.endsAt = promotion.endsAt
        savedPromotion.expires = promotion.expires
        
        for savedProduct in promotion.products.map({ productStore.createProductObject(product: $0) }) {
            savedPromotion.products.append(savedProduct)
        }
        
        return savedPromotion
    }
}
