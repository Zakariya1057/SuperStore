//
//  ReviewData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ListsDataResponse: Decodable {
    var data: [ListData]
}

struct ListData: Decodable {
    var id: Int
    var created_at: String
    var name: String
    var status: String
    var store_id: Int
    var user_id: Int
    var total_price: Double
    var categories: [ListCategoryData]?
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
}
