//
//  PromotionData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct PromotionDataResponse: Decodable {
    var data: PromotionData
}

struct PromotionData:Decodable {
    var id: Int
    var name: String
    var quantity: Int
    var price: Double?
    var for_quantity: Int?
    let products: [ProductData]?
    
    func getPromotionModel() -> PromotionModel {
        return PromotionModel(id: id, name: name, quantity: quantity, price: price, forQuantity: for_quantity)
    }
}
