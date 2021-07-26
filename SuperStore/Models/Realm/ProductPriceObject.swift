//
//  ProductPriceObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/07/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductPriceObject: Object {
    @objc dynamic var regionID: Int = 1
    @objc dynamic var supermarketChainID: Int = 1
    
    @objc dynamic var price: Double = 0
    var oldPrice = RealmOptional<Double>()
    var isOnSale = RealmOptional<Bool>()
    
    var promotionID = RealmOptional<Int>()
    
    @objc dynamic var promotion: PromotionObject? = nil
    
    @objc dynamic var saleEndsAt: Date? = nil
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    func getProductPriceModel() -> ProductPriceModel {
        return ProductPriceModel(
            regionID: regionID,
            supermarketChainID: supermarketChainID,
            
            price: price,
            oldPrice: oldPrice.value,
            isOnSale: isOnSale.value,
            saleEndsAt: saleEndsAt,
            
            promotion: nil
        )
    }
}
