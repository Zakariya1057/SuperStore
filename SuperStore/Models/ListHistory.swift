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
    @objc dynamic var id: Int = 1
    @objc dynamic var index: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var store_id: Int = 1
    @objc dynamic var user_id: Int = 1
    @objc dynamic var total_price: Double = 0
    @objc dynamic var old_total_price: Double = 0
    var categories = List<ListCategoryHistory>()
    @objc dynamic var created_at: Date = Date()
    @objc dynamic var updated: Date = Date()
    
    func getListModel() -> ListModel {
        var categoryItems:[ListCategoryModel] = []
        
        for category in categories {
            categoryItems.append(category.getCategoryModel())
        }
        return ListModel(id: self.id, name: self.name, created_at: self.created_at, status: ListStatus(rawValue: self.status)!,index: self.index,user_id: self.user_id, total_price: self.total_price, categories:categoryItems)
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
    var items = List<ListItemHistory>()
    
    func getCategoryModel() -> ListCategoryModel {
        var listItems: [ListItemModel] = []
        
        for item in items {
            listItems.append(item.getItemModel())
        }
        
        return ListCategoryModel(id: self.id, name: self.name, aisle_name: self.aisle_name, items: listItems, list_id: list_id)
    }
}

class ListItemHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var total_price: Double = 0
    @objc dynamic var price: Double = 0
    @objc dynamic var product_id: Int = 1
    @objc dynamic var quantity: Int = 1
    @objc dynamic var image: String = ""
    @objc dynamic var ticked_off: Bool = false
    @objc dynamic var weight: String = ""
    @objc dynamic var discount: DiscountHistory? = nil
    @objc dynamic var list_id: Int = 1
    
    func getItemModel() -> ListItemModel {
        return ListItemModel(id: self.id, name: self.name, total_price: self.total_price, price: self.price, product_id: self.product_id, quantity: self.quantity, image: self.image, ticked_off: self.ticked_off, weight: self.weight, discount: self.discount?.getDiscountModel(), list_id: self.list_id)
    }
}
