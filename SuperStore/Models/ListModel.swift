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
    var created_at: Date
    var status: ListStatus
    var store_id: Int?
    var user_id: Int
    var total_price: Double
    var old_total_price: Double?
    var categories: [ListCategoryModel]
    
    func getRealmObject() -> ListHistory {
        var list = ListHistory()
        list.id = self.id
        list.name = self.name
        list.created_at = Date()
        list.status = self.status.rawValue
        list.total_price = self.total_price
//        list.categories = []
        list.old_total_price = self.old_total_price ?? 0
        return list
    }
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
    var discount: DiscountModel?
}

enum ListStatus: String {
    case completed
    case inProgress
    case notStarted
}

struct ListProgressModel: Decodable {
    var id: Int
    var name: String
    var totalItems: Int
    var tickedOffItems: Int
}
