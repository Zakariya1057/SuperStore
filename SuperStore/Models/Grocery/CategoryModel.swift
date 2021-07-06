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
    var index: Int
    var companyID: Int
    var parentCategories: [ParentCategoryModel]
}

struct ParentCategoryModel {
    var id: Int
    var name: String
    var index: Int
    var grandParentCategoryID: Int
    var companyID: Int
    var childCategories: [ChildCategoryModel]
}

struct ChildCategoryModel {
    var id: Int
    var name: String
    var index: Int
    var parentCategoryID: Int
    var companyID: Int
    var products: [ProductModel]
    
    var paginate: PaginateResultsModel?
}
