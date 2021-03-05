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

struct ListData: Decodable {
    var id: Int
    var identifier: String
    var name: String
    var status: String
    var store_type_id: Int
    var user_id: Int
    var total_price: Double
    
    var ticked_off_items: Int
    var total_items: Int
    
    var old_total_price: Double?
    var categories: [ListCategoryData]?
    var updated_at: String
    var created_at: String
    
    func getListModel() -> ListModel {
        var listStatus: ListStatus = .notStarted
        
        if status.contains("completed"){
            listStatus = .completed
        } else if status.contains("in progress"){
            listStatus = .inProgress
        } else if status.contains("not started"){
            listStatus = .notStarted
        }
        
//        let dateFormat: DateFormatter = DateFormatter()
//        dateFormat.dateFormat = "dd MMMM Y"
//
//        let createdDate: Date = dateFormat.date(from: created_at)!
        
        return ListModel(
            id: id,
            name: name,
            status: listStatus,
            identifier: identifier,
            storeTypeID: store_type_id,
            userID: user_id,
            totalPrice: total_price,
            oldTotalPrice: old_total_price,
            categories: [],
            totalItems: total_items,
            tickedOffItems: ticked_off_items,
            createdAt: created_at
        )
    }
}

struct ListCategoryData:Decodable {
    var id: Int
    var name: String
    var aisle_name: String?
    var items: [ListItemData]
}

struct ListItemData: Decodable {
    var id: Int
    var name: String
    var total_price: Double
    var price: Double
    var product_id: Int
    var quantity: Int
    var large_image: String?
    var small_image: String?
    var ticked_off: Bool
    var weight: String?
    var promotion: PromotionData?
}

struct ListProgressData: Decodable {
    var id: Int
    var identifier: String
    var name: String
    var total_items: Int
    var ticked_off_items: Int
}
