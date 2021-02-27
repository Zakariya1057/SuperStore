////
////  ReviewData.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 29/08/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import Foundation
//
//struct ListsDataResponse: Decodable {
//    var data: [ListData]
//}
//
//struct ListData: Decodable {
//    var id: Int
//    var identifier: String
//    var name: String
//    var status: String
//    var store_id: Int?
//    var user_id: Int
//    var total_price: Double
//    
//    var ticked_off_items: Int
//    var total_items: Int
//    
//    var old_total_price: Double?
//    var categories: [ListCategoryData]?
//    var updated_at: String
//    var created_at: String
//}
//
//struct ListCategoryData:Decodable {
//    var id: Int
//    var name: String
//    var aisle_name: String?
//    var items: [ListItemData]
//}
//
//struct ListItemData: Decodable {
//    var id: Int
//    var name: String
//    var total_price: Double
//    var price: Double
//    var product_id: Int
//    var quantity: Int
//    var large_image: String?
//    var small_image: String?
//    var ticked_off: Bool
//    var weight: String?
//    var promotion: PromotionData?
//}
//
//struct ListProgressData: Decodable {
//    var id: Int
//    var identifier: String
//    var name: String
//    var total_items: Int
//    var ticked_off_items: Int
//}
