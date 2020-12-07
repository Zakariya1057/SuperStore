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
    @objc dynamic var oldTotalPrice: Double = 0
    
    @objc dynamic var synced: Bool = false
    @objc dynamic var deleted: Bool = false
    @objc dynamic var edited: Bool = false
    @objc dynamic var mode: String = "overwrite" // Append to online list instead of overwrite. (Append/Overwrite)
    
    var categories = List<ListCategoryHistory>()
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    func getListModel() -> ListModel {
        var categoryItems:[ListCategoryModel] = []
        
        for category in categories {
            categoryItems.append(category.getCategoryModel())
        }
        return ListModel(id: self.id, name: self.name, createdAt: self.createdAt, status: ListStatus(rawValue: self.status)!,identifier: self.identifier,userID: self.user_id, totalPrice: self.totalPrice, categories:categoryItems, totalItems: self.totalItems, tickedOffItems: self.tickedOffItems)
    }
    
    func restartList(){
        self.status = ListStatus.notStarted.rawValue
        
        for category in categories {
            for item in category.items {
                item.tickedOff = false
            }
        }
    }
    
}

class ListCategoryHistory:Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var aisleName: String = ""
    @objc dynamic var listID: Int = 1
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    var items = List<ListItemHistory>()
    
    func getCategoryModel() -> ListCategoryModel {
        var listItems: [ListItemModel] = []
        
        for item in items {
            if item.deleted == false {
                listItems.append(item.getItemModel())
            }
        }

        return ListCategoryModel(id: self.id, name: self.name, aisleName: self.aisleName, items: listItems, listID: self.listID)
    }
}

class ListItemHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var totalPrice: Double = 0
    @objc dynamic var price: Double = 0
    @objc dynamic var productID: Int = 1
    @objc dynamic var quantity: Int = 1
    @objc dynamic var image: String = ""
    @objc dynamic var tickedOff: Bool = false
    @objc dynamic var weight: String = ""
    @objc dynamic var promotion: PromotionHistory? = nil
    @objc dynamic var listID: Int = 1
    @objc dynamic var createdAt: Date = Date()
    
    @objc dynamic var deleted: Bool = false
    @objc dynamic var edited: Bool = true
    @objc dynamic var synced: Bool = false
    
    func getItemModel() -> ListItemModel {
        return ListItemModel(id: self.id, name: self.name, image: self.image, quantity: self.quantity, productID: self.productID, price: self.price, weight: self.weight, promotion: self.promotion?.getPromotionModel(), listID: self.listID, tickedOff: self.tickedOff)
    }
}
