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
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var store_id: Int = 1
    @objc dynamic var user_id: Int = 1
    @objc dynamic var total_price: Double = 0
    @objc dynamic var old_total_price: Double = 0
    let categories = List<ListCategoryHistory>()
    @objc dynamic var created_at: Date = Date()
    @objc dynamic var updated: Date = Date()
    
    func getListModel() -> ListModel {
        return ListModel(id: self.id, name: self.name, created_at: self.created_at, status: ListStatus(rawValue: self.status)!, user_id: self.user_id, total_price: self.total_price, categories:[])
    }
}

class ListCategoryHistory:Object {
//    @objc dynamic var id: Int = 1
//    @objc dynamic var name: String = ""
//    @objc dynamic var aisle_name: String? = nil
//    @objc dynamic var items: [ListItemHistory] = []
}
//
//class ListItemHistory: Object {
//
//}
