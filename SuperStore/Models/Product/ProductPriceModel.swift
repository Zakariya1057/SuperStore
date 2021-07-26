//
//  ProductPriceModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/07/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductPriceModel {
    var regionID: Int = 1
    var supermarketChainID: Int = 1
    
    var price: Double
    var oldPrice: Double?
    var isOnSale: Bool?
    
    var saleEndsAt: Date?
    
    var promotion: PromotionModel?
    
    init(regionID: Int, supermarketChainID: Int, price: Double, oldPrice: Double?, isOnSale: Bool?, saleEndsAt: Date?, promotion: PromotionModel?) {
        self.regionID = regionID
        self.supermarketChainID = supermarketChainID
        
        self.price = price
        self.oldPrice = oldPrice
        self.isOnSale = isOnSale
        self.saleEndsAt = saleEndsAt
        
        let dateWorker = DateWorker()
        
        setPromotion(dateWorker: dateWorker, promotion: promotion)
        setSalePrices(dateWorker: dateWorker, oldPrice: oldPrice, isOnSale: isOnSale, saleEndsAt: saleEndsAt)
    }
    
    private func setPromotion(dateWorker: DateWorker, promotion: PromotionModel?){
        if let promotion = promotion {
            if let endsAt = promotion.endsAt {
                if dateWorker.dateDiff(date: endsAt) >= 0 {
                    self.promotion = promotion
                }
            } else {
                self.promotion = promotion
            }
        }
    }
    
    private func setSalePrices(dateWorker: DateWorker, oldPrice: Double?, isOnSale: Bool?, saleEndsAt: Date?){
        // On model creation, check if sale, promotion expired. If has, then never set in the model.
        self.saleEndsAt = saleEndsAt
        
        if let saleEndsAt = saleEndsAt, let oldPrice = oldPrice {
            if dateWorker.dateDiff(date: saleEndsAt) < 0 {
                self.price = oldPrice
                self.isOnSale = false
                self.oldPrice = nil
            } else {
                self.oldPrice = oldPrice
                self.isOnSale = isOnSale
            }
        } else {
            self.oldPrice = oldPrice
            self.isOnSale = isOnSale
        }
    }
    
}
