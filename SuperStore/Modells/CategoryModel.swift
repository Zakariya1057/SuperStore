//
//  CategoryModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct GrandParentCategoryModel {
    var id: Int
    var name:String
    var parentCategories: [ParentCategoryModel]
}

struct ParentCategoryModel {
    var id: Int
    var name:String
    var childCategories: [ChildCategoryModel]
}

struct ChildCategoryModel {
    var id: Int
    var name: String
    var parentCategoryID: Int
    var products: [ProductModel]
}
