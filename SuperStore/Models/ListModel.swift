//
//  ListModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

struct ListModel {
    var id: Int
    var name: String
    var created_at: Date
    var status: ListStatus
    var index: Int
    var store_id: Int?
    var user_id: Int
    var total_price: Double
    var old_total_price: Double?
    var categories: [ListCategoryModel]
    
    func getRealmObject() -> ListHistory {
        let list = ListHistory()
        list.id = self.id
        list.name = self.name
        list.index = self.index
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
    
    func getRealmObject() -> ListCategoryHistory {
        let category = ListCategoryHistory()
        
        category.id = self.id
        category.name = self.name
        
        let items = List<ListItemHistory>()

        for item in self.items {
            items.append(item.getRealmObject())
        }
        
        category.items = items
        
        return category
    }
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
    
    func getRealmObject() -> ListItemHistory {
        let list = ListItemHistory()
        list.id = self.id
        list.name = self.name
        list.price = self.price
        list.total_price = self.total_price
        list.product_id = self.product_id
        list.quantity = self.quantity
        list.image = self.image
        list.ticked_off = self.ticked_off
        list.weight = self.weight ?? ""
        list.discount = self.discount?.getRealmObject()
        return list
    }
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
