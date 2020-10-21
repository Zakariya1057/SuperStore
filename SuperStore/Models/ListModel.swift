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
    var identifier: String
    var store_id: Int?
    var user_id: Int
    var totalPrice: Double
    var old_total_price: Double?
    var categories: [ListCategoryModel]
    var totalItems: Int
    var tickedOffItems: Int
    
    func getRealmObject() -> ListHistory {
        let list = ListHistory()
        list.id = self.id
        list.name = self.name
        list.identifier = self.identifier
        list.created_at = Date()
        list.status = self.status.rawValue
        list.totalPrice = self.totalPrice
        list.tickedOffItems = self.tickedOffItems
        list.totalItems = self.totalItems
        list.old_total_price = self.old_total_price ?? 0
        return list
    }
}

struct ListCategoryModel {
    var id: Int
    var name: String
    var aisle_name: String?
    var items: [ListItemModel]
    var list_id: Int
    
    func getRealmObject() -> ListCategoryHistory {
        let category = ListCategoryHistory()
        
        category.id = self.id
        category.name = self.name
        category.list_id = self.list_id
        
        let items = List<ListItemHistory>()

        for item in self.items {
            items.append(item.getRealmObject())
        }
        
        category.items = items
        
        return category
    }
}

class ListItemModel: ProductItemModel {
    var id: Int
    var ticked_off: Bool
    var list_id: Int
    
    init(id: Int, name: String, image: String, quantity: Int, product_id: Int, price: Double, weight: String?, promotion: PromotionModel?, list_id: Int, ticked_off: Bool) {
        self.list_id = list_id
        self.ticked_off = ticked_off
        self.id = id
        
        super.init(name: name, image: image, quantity: quantity, product_id: product_id, price: price, weight: weight, promotion: promotion)

    }
    
    func getRealmObject() -> ListItemHistory {
        let list = ListItemHistory()
        list.id = self.id
        list.name = self.name
        list.price = self.price
        list.totalPrice = self.totalPrice
        list.product_id = self.product_id
        list.quantity = self.quantity
        list.image = self.image
        list.ticked_off = self.ticked_off
        list.weight = self.weight ?? ""
        list.promotion = self.promotion?.getRealmObject()
        list.list_id = self.list_id
        return list
    }
}

enum ListStatus: String {
    case completed
    case inProgress
    case notStarted
}
