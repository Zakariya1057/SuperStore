//
//  ListObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ListObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = ""
    
    @objc dynamic var identifier: String = ""
    @objc dynamic var storeTypeID: Int = 1
    
    var categories = List<ListCategoryObject>()
    
    var oldTotalPrice =  RealmOptional<Double>()
    
    @objc dynamic var totalPrice: Double = 0
    @objc dynamic var currency: String = ""
    
    @objc dynamic var totalItems: Int = 0
    @objc dynamic var tickedOffItems: Int = 0
    
    @objc dynamic var deleted: Bool = false
    @objc dynamic var edited: Bool = false
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getListModel() -> ListModel {
        return ListModel(
            id: id,
            name: name,
            status: ListStatus.init(rawValue: status)!,
            identifier: identifier,
            storeTypeID: storeTypeID,
            categories: categories.map{ $0.getListCategoryModel() },
            totalPrice: totalPrice,
            oldTotalPrice: oldTotalPrice.value,
            currency: currency,
            totalItems: totalItems,
            tickedOffItems: tickedOffItems,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    
    override static func primaryKey() -> String? {
         return "id"
    }
}

class ListCategoryObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var listID: Int = 1
    
    var items = List<ListItemObject>()
    
    func getListCategoryModel() -> ListCategoryModel {
        return ListCategoryModel(
            id: id,
            name: name,
            items: items.map{$0.getListItemModel()}
        )
    }
    
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
}

