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
    var parentCategoryId: Int
    var products: [ProductData]
}
