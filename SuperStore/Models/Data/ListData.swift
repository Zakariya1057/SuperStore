//
//  ListResponseData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ListsDataResponse: Decodable {
    var data: [ListData]
}

struct ListDataResponse: Decodable {
    var data: ListData
}

struct ListItemDataResponse: Decodable {
    var data: ListItemData
}

struct ListData: Decodable {
    var id: Int
    var identifier: String
    var name: String
    var status: String
    var store_type_id: Int
    var user_id: Int
    
    var total_price: Double
    var currency: String
    
    var ticked_off_items: Int
    var total_items: Int
    
    var old_total_price: Double?
    var categories: [ListCategoryData]?
    
    var updated_at: String
    var created_at: String
    
    func getListModel() -> ListModel {
        var listStatus: ListStatus = .notStarted
        
        let dateWorker = DateWorker()

        let status = self.status.lowercased()
        
        if status.contains("completed"){
            listStatus = .completed
        } else if status.contains("in progress"){
            listStatus = .inProgress
        } else if status.contains("not started"){
            listStatus = .notStarted
        }
        
        return ListModel(
            id: id,
            name: name,
            status: listStatus,
            identifier: identifier,
            storeTypeID: store_type_id,
            categories: (categories ?? []).map{ $0.getCategoryModel() },
            totalPrice: total_price,
            oldTotalPrice: old_total_price,
            currency: currency,
            totalItems: total_items,
            tickedOffItems: ticked_off_items,
            createdAt: dateWorker.formatDate(date: created_at),
            updatedAt: dateWorker.formatDate(date: updated_at)
        )
    }
}

struct ListCategoryData:Decodable {
    var id: Int
    var name: String
    var items: [ListItemData]
    
    func getCategoryModel() -> ListCategoryModel {
        return ListCategoryModel(
            id: id,
            name: name,
            items: items.map{ $0.getListItemModel() }
        )
    }
}

struct ListItemData: Decodable {
    var id: Int
    var name: String
    var total_price: Double
    var price: Double
    var currency: String
    var product_id: Int
    var quantity: Int
    var large_image: String?
    var small_image: String?
    var ticked_off: Bool
    var weight: String?
    var promotion: PromotionData?
    
    func getListItemModel() -> ListItemModel {
        return ListItemModel(
            id: id,
            name: name,
            productID: product_id,
            image: large_image,
            price: price,
            currency: currency,
            totalPrice: total_price,
            quantity: quantity,
            weight: weight,
            promotion: promotion?.getPromotionModel(),
            tickedOff: ticked_off
        )
    }
}


struct ListProgressData: Decodable {
    var id: Int
    var identifier: String
    var name: String
    var total_items: Int
    var ticked_off_items: Int
}
