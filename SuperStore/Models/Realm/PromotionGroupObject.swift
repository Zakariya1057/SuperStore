//
//  PromotionHistoryObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class PromotionGroupObject: Object {
    @objc dynamic var title: String = ""
    
    @objc dynamic var regionID: Int = 1
    @objc dynamic var supermarketChainID: Int = 1
    
    var promotions = List<PromotionObject>()
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getPromotionGroupModel() -> PromotionGroupModel {
        return PromotionGroupModel(
            title: title,
            regionID: regionID,
            supermarketChainID: supermarketChainID,
            promotions: promotions.map{ $0.getPromotionModel() }
        )
    }
    
    override static func indexedProperties() -> [String] {
        return ["regionID", "supermarketChainID"]
    }
}

