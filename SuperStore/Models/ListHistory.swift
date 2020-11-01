//
//  SearchRealmModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ListHistory: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var store_id: Int = 1
    @objc dynamic var user_id: Int = 1
    
    @objc dynamic var totalItems: Int = 0
    @objc dynamic var tickedOffItems: Int = 0
    
    @objc dynamic var totalPrice: Double = 0
    @objc dynamic var old_total_price: Double = 0
    
    @objc dynamic var synced: Bool = false
    @objc dynamic var deleted: Bool = false
    @objc dynamic var edited: Bool = false
    var categories = List<ListCategoryHistory>()
    
    @objc dynamic var created_at: Date = Date()
    @objc dynamic var updated: Date = Date()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    func getListModel() -> ListModel {
        var categoryItems:[ListCategoryModel] = []
        
        for category in categories {
            categoryItems.append(category.getCategoryModel())
        }
        return ListModel(id: self.id, name: self.name, created_at: self.created_at, status: ListStatus(rawValue: self.status)!,identifier: self.identifier,user_id: self.user_id, totalPrice: self.totalPrice, categories:categoryItems, totalItems: self.totalItems, tickedOffItems: self.tickedOffItems)
    }
    
    func restartList(){
        self.status = ListStatus.notStarted.rawValue
        
        for category in categories {
            for item in category.items {
                item.ticked_off = false
            }
        }
    }
    
}

class ListCategoryHistory:Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var aisle_name: String = ""
    @objc dynamic var list_id: Int = 1
    @objc dynamic var created_at: Date = Date()
    var items = List<ListItemHistory>()
    
    func getCategoryModel() -> ListCategoryModel {
        var listItems: [ListItemModel] = []
        
        for item in items {
            if item.deleted == false {
                listItems.append(item.getItemModel())
            }
        }

        return ListCategoryModel(id: self.id, name: self.name, aisle_name: self.aisle_name, items: listItems, list_id: list_id)
    }
}

class ListItemHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var totalPrice: Double = 0
    @objc dynamic var price: Double = 0
    @objc dynamic var product_id: Int = 1
    @objc dynamic var quantity: Int = 1
    @objc dynamic var image: String = ""
    @objc dynamic var ticked_off: Bool = false
    @objc dynamic var weight: String = ""
    @objc dynamic var promotion: PromotionHistory? = nil
    @objc dynamic var list_id: Int = 1
    @objc dynamic var created_at: Date = Date()
    
    @objc dynamic var deleted: Bool = false
    @objc dynamic var edited: Bool = true
    @objc dynamic var synced: Bool = false
    
    func getItemModel() -> ListItemModel {
        return ListItemModel(id: self.id, name: self.name, image: self.image, quantity: self.quantity, product_id: self.product_id, price: self.price, weight: self.weight, promotion: self.promotion?.getPromotionModel(), list_id: self.list_id, ticked_off: self.ticked_off)
    }
}
