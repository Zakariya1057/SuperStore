//
//  ProductPriceRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/07/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductPriceRealmStore: DataStore {
    
    private lazy var promotionStore: PromotionRealmStore = PromotionRealmStore()
    
    func createProductPriceRealmObject(price: ProductPriceModel) -> ProductPriceObject {
        let savedProductPrice = ProductPriceObject()
        
        savedProductPrice.regionID = price.regionID
        savedProductPrice.supermarketChainID = price.supermarketChainID
        
        savedProductPrice.price = price.price
        updateOldTotalPrice(price: price, savedPrice: savedProductPrice)
        
        createPromotion(price: price, savedPrice: savedProductPrice)

        return savedProductPrice
    }
    
    func updateProductPrices(savedProduct: ProductObject, price: ProductPriceModel){
        let savedPrice = savedProduct.prices.first { savedPrice in savedPrice.regionID == price.regionID && savedPrice.supermarketChainID == price.supermarketChainID }
        
        if let savedPrice = savedPrice {
            updateProductPriceRealmObject(savedProductPrice: savedPrice, price: price)
        } else {
            savedProduct.prices.append( createProductPriceRealmObject(price: price) )
        }
    }
    
    func updateProductPriceRealmObject(savedProductPrice: ProductPriceObject, price: ProductPriceModel){
        savedProductPrice.price = price.price
        updateOldTotalPrice(price: price, savedPrice: savedProductPrice)
        setProductPricePromotion(price: price, savedPrice: savedProductPrice)
    }
    
    func setProductPricePromotion(price: ProductPriceModel, savedPrice: ProductPriceObject){
        if let promotionID = savedPrice.promotionID.value {
            let promotion: PromotionModel? = promotionStore.getPromotion(promotionID: promotionID)
            
            if let promotion = promotion {
                if promotionStore.promotionExpired(promotion: promotion){
                    deleteProductPromotion(savedPrice: savedPrice, promotionID: promotion.id)
                }
            }
            
            price.promotion = promotion
        }
    }
    
    func deleteProductPromotion(savedPrice: ProductPriceObject, promotionID: Int){
        if let inWrite = realm?.isInWriteTransaction, inWrite {
            savedPrice.promotionID.value = nil
        } else {
            try? realm?.write({
                savedPrice.promotionID.value = nil
            })
        }
    
        promotionStore.deletePromotion(promotionID: promotionID)
    }
}

extension ProductPriceRealmStore {
    func createPromotion(price: ProductPriceModel, savedPrice: ProductPriceObject){
        // If promotion already expired, don't insert that
        if let promotion = price.promotion {
            if !promotionStore.promotionExpired(promotion: promotion) {
                savedPrice.promotion = promotionStore.createPromotionObject(promotion: promotion)
                savedPrice.promotionID.value = promotion.id
            }
        }
    }
    
    func updatePromotion(price: ProductPriceModel, savedPrice: ProductPriceObject){
        if let promotion = price.promotion {
            if promotionStore.promotionExpired(promotion: promotion) {
                // If present locally, then delete
                if savedPrice.promotionID.value != nil {
                    promotionStore.deletePromotion(promotionID: savedPrice.promotionID.value!)
                    savedPrice.promotionID.value = nil
                }
            } else {
                savedPrice.promotion = promotionStore.createPromotionObject(promotion: promotion)
                savedPrice.promotionID.value = promotion.id
            }
        } else {
            if savedPrice.promotionID.value != nil {
                promotionStore.deletePromotion(promotionID: savedPrice.promotionID.value!)
                savedPrice.promotionID.value = nil
            }
        }
    }
}

extension ProductPriceRealmStore {
    func updateOldTotalPrice(price: ProductPriceModel, savedPrice: ProductPriceObject){
        var saleEndsAt = price.saleEndsAt
        
        let dateWorker = DateWorker()
        
        if price.oldPrice != nil {
            if let endsAt = saleEndsAt {
                if dateWorker.dateDiff(date: endsAt) > 0 {
                    savedPrice.oldPrice.value = price.oldPrice!
                    savedPrice.isOnSale.value = true
                } else {
                    saleEndsAt = nil
                    savedPrice.isOnSale.value = nil
                    savedPrice.oldPrice.value = nil
                    savedPrice.price = price.oldPrice!
                }
            } else {
                savedPrice.oldPrice.value = price.oldPrice!
                savedPrice.isOnSale.value = true
            }
        } else {
            savedPrice.oldPrice.value = nil
            savedPrice.isOnSale.value = nil
            saleEndsAt = nil
        }
        
        savedPrice.saleEndsAt = saleEndsAt
    }
    
}
