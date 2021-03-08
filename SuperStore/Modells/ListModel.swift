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

    var totalItems: Int
    var tickedOffItems: Int
    
    var createdAt: Date
    var updatedAt: Date
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
    var totalPrice: Double
    var quantity: Int
    var weight: String?
    var promotion: PromotionModel?
    var tickedOff: Bool
}

enum ListStatus: String {
    case completed
    case inProgress
    case notStarted
}
