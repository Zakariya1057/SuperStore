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
    
    func getRealmObject() -> ListHistory {
        let list = ListHistory()
        list.id = self.id
        list.name = self.name
        list.identifier = self.identifier
        list.created_at = Date()
        list.status = self.status.rawValue
        list.totalPrice = self.totalPrice
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
    
    init(id: Int, name: String, image: String, quantity: Int, product_id: Int, price: Double, weight: String?, discount: DiscountModel?, list_id: Int, ticked_off: Bool) {
        self.list_id = list_id
        self.ticked_off = ticked_off
        self.id = id
        
        super.init(name: name, image: image, quantity: quantity, product_id: product_id, price: price, weight: weight, discount: discount)

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
        list.discount = self.discount?.getRealmObject()
        list.list_id = self.list_id
        return list
    }
}

//struct ListItemModel {
//    var id: Int
//    var name: String
//    var totalPrice: Double
//    var price: Double
//    var product_id: Int
//    var quantity: Int
//    var image: String
//    var ticked_off: Bool
//    var weight: String?
//    var discount: DiscountModel?
//    var list_id: Int
//
//    func getRealmObject() -> ListItemHistory {
//        let list = ListItemHistory()
//        list.id = self.id
//        list.name = self.name
//        list.price = self.price
//        list.totalPrice = self.totalPrice
//        list.product_id = self.product_id
//        list.quantity = self.quantity
//        list.image = self.image
//        list.ticked_off = self.ticked_off
//        list.weight = self.weight ?? ""
//        list.discount = self.discount?.getRealmObject()
//        list.list_id = self.list_id
//        return list
//    }
//}

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
