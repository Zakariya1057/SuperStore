//
//  PromotionRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class PromotionRealmStore: DataStore {
    func createPromotionObject(promotion: PromotionModel) -> PromotionObject {
        let savedPromotion = PromotionObject()
        
        savedPromotion.id = promotion.id
        savedPromotion.name = promotion.name
        
        savedPromotion.price = promotion.price
        savedPromotion.forQuantity = promotion.forQuantity
        savedPromotion.quantity = promotion.quantity
        
        savedPromotion.startsAt = promotion.startsAt
        savedPromotion.endsAt = promotion.endsAt
        savedPromotion.expires = promotion.expires
        
        return savedPromotion
    }
}
