//
//  ListModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ListModel {
    var id: Int
    var name: String
    var status: ListStatus
    var identifier: String
    var storeTypeID: Int
   
    var categories: [ListCategoryModel]
    
    var totalPrice: Double
    var oldTotalPrice: Double?
    
    var currency: String

    var totalItems: Int
    var tickedOffItems: Int
    
    var createdAt: Date
    var updatedAt: Date
    
    func getTotalPrice() -> String {
        return formatPrice(price: totalPrice)
    }
    
    func getOldTotalPrice() -> String? {
        return oldTotalPrice != nil ? formatPrice(price: oldTotalPrice!) : nil
    }
    
    private func formatPrice(price: Double) -> String {
        return currency + String(format: "%.2f", price)
    }
}


struct ListCategoryModel {
    var id: Int
    var name: String
    var items: [ListItemModel]
}

struct ListItemModel {
    var id: Int
    var name: String
    var productID: Int
    var image: String?
    var price: Double
    var currency: String
    var totalPrice: Double
    var quantity: Int
    var weight: String?
    var promotion: PromotionModel?
    var tickedOff: Bool
    
    func getPrice() -> String {
        return currency + String(format: "%.2f", totalPrice)
    }
}

enum ListStatus: String {
    case completed
    case inProgress
    case notStarted
}
