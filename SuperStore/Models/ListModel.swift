//
//  ListModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ListModel {
    var id: Int
    var name: String
    var created_at: String
    var status: ListStatus
    var store_id: Int
    var user_id: Int
    var total_price: Double
    var categories: [ListCategoryModel]
}

struct ListCategoryModel {
    var id: Int
    var name: String
    var aisle_name: String?
    var items: [ListItemModel]
}

struct ListItemModel {
    var id: Int
    var name: String
    var total_price: Double
    var price: Double
    var product_id: Int
    var quantity: Int
    var image: String
    var ticked_off: Bool
    var weight: String?
}

enum ListStatus {
    case completed
    case inProgress
    case notStarted
}
