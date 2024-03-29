//
//  PromotionData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct AllPromotionsDataResponse: Decodable {
    var data: [String]
}

struct PromotionGroupDataResponse: Decodable {
    var data: [PromotionData]
}


struct PromotionDataResponse: Decodable {
    var data: PromotionData
}

struct PromotionData:Decodable {
    var id: Int
    
    var title: String?
    var name: String
    
    var quantity: Int?
    var price: Double?
    var for_quantity: Int?
    
    var maximum: Int?
    var minimum: Int?
    
    var products: [ProductData]?
    var supermarket_chain_id: Int
    
    var expires: Bool?
    var starts_at: String?
    var ends_at: String?
    
    func getPromotionModel() -> PromotionModel {
        let dateWorker = DateWorker()
        
        return PromotionModel(
            id: id,
            title: title,
            name: name,
            supermarketChainID: supermarket_chain_id,
            
            quantity: quantity,
            price: price,
            forQuantity: for_quantity,
            minimum: minimum,
            maximum: maximum,
            
            products: products?.map({ (product: ProductData) in
                return product.getProductModel()
            }) ?? [],
            
            expires: expires ?? false,
            
            startsAt: starts_at != nil ? dateWorker.formatDate(date: starts_at!) : nil,
            endsAt: ends_at != nil ? dateWorker.formatDate(date: ends_at!) : nil
        )
    }
}
