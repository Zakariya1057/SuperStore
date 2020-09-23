//
//  GroceryModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct GrandParentCategoryModel {
    var id: Int
    var name:String
    var child_categories: [ChildCategoryModel]
}

struct ChildCategoryModel {
    var id: Int
    var name:String
}
