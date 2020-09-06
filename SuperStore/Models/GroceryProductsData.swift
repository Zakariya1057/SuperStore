//
//  GroceryData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct GroceryProductsResponseData: Decodable {
    var data: [GroceryProductsData]
}

struct GroceryProductsData:Decodable {
    var id: Int
    var name:String
    var products: [ProductData]
}

//struct GroceryProductData:Decodable {
//    var id: Int
//    var name: String
//    var large_image: String
//    var small_image: String
//    var description: String?
//    var price: String
//    var promotion: PromotionData?
////    var location: String
//}
