//
//  GroceryData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct GroceryCategoriesResponseData: Decodable {
    var data: [GroceryCategoriesData]
}

struct GroceryCategoriesData:Decodable {
    var id: Int
    var name:String
    var child_categories: [ChildCategoryData]
}

struct ChildCategoryData:Decodable {
    var id: Int
    var name:String
}
