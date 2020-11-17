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
    var createdAt: Date
    var status: ListStatus
    var identifier: String
    var storeID: Int?
    var userID: Int
    var totalPrice: Double
    var oldTotalPrice: Double?
    var categories: [ListCategoryModel]
    var totalItems: Int
    var tickedOffItems: Int
    
    func getRealmObject() -> ListHistory {
        let list = ListHistory()
        list.id = self.id
        list.name = self.name
        list.identifier = self.identifier
        list.createdAt = Date()
        list.status = self.status.rawValue
        list.totalPrice = self.totalPrice
        list.tickedOffItems = self.tickedOffItems
        list.totalItems = self.totalItems
        list.oldTotalPrice = self.oldTotalPrice ?? 0
        return list
    }
}

struct ListCategoryModel {
    var id: Int
    var name: String
    var aisleName: String?
    var items: [ListItemModel]
    var listID: Int
    
    func getRealmObject() -> ListCategoryHistory {
        let category = ListCategoryHistory()
        
        category.id = self.id
        category.name = self.name
        category.listID = self.listID
        
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
    var tickedOff: Bool
    var listID: Int
    
    init(id: Int, name: String, image: String, quantity: Int, productID: Int, price: Double, weight: String?, promotion: PromotionModel?, listID: Int, tickedOff: Bool) {
        self.listID = listID
        self.tickedOff = tickedOff
        self.id = id
        
        super.init(name: name, smallImage: image, largeImage: image, quantity: quantity, productID: productID, price: price, weight: weight, promotion: promotion)

    }
    
    func getRealmObject() -> ListItemHistory {
        let list = ListItemHistory()
        list.id = self.id
        list.name = self.name
        list.price = self.price
        list.totalPrice = self.totalPrice
        list.productID = self.productID
        list.quantity = self.quantity
        list.image = self.largeImage
        list.tickedOff = self.tickedOff
        list.weight = self.weight ?? ""
        list.promotion = self.promotion?.getRealmObject()
        list.listID = self.listID
        return list
    }
}

enum ListStatus: String {
    case completed
    case inProgress
    case notStarted
}
