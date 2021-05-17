//
//  CategoryData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct GrandParentCategoriesDataResponse: Decodable {
    var data: [GrandParentCategoryData]
}

struct ChildCategoriesDataResponse: Decodable {
    var data: [ChildCategoryData]
}

struct CategoryProductsDataResponse: Decodable {
    var data: ChildCategoryData?
}

struct GrandParentCategoryData: Decodable {
    var id: Int
    var name: String
    
    var index: Int
    
    var store_type_id: Int
    
    var parent_categories: [ParentCategoryData]
    
    func getParentCategoryModel() -> GrandParentCategoryModel {
        return GrandParentCategoryModel(
            id: id,
            name: name,
            index: index,
            storeTypeID: store_type_id,
            parentCategories: parent_categories.map { $0.getParentCategoryModel() }
        )
    }
}

struct ParentCategoryData: Decodable {
    var id: Int
    var name: String
    var parent_category_id: Int
    
    var index: Int
    
    var store_type_id: Int
    
    var child_categories: [ChildCategoryData]?
    
    func getParentCategoryModel() -> ParentCategoryModel {
        return ParentCategoryModel(
            id: id,
            name: name,
            index: index,
            grandParentCategoryID: parent_category_id,
            storeTypeID: store_type_id,
            childCategories: (child_categories ?? []).map { $0.getChildCategoryModel() }
        )
    }
}

struct ChildCategoryData:Decodable {
    var id: Int
    var name: String
    var parent_category_id: Int
    
    var index: Int
    
    var store_type_id: Int
    
    var products: [ProductData]?
    
    let paginate: PaginateResultsData?
    
    func getChildCategoryModel() -> ChildCategoryModel {
        return ChildCategoryModel(
            id: id,
            name: name,
            index: index,
            parentCategoryID: parent_category_id,
            storeTypeID: store_type_id,
            products: products?.map{ $0.getProductModel() } ?? [],
            paginate: paginate?.getPaginateResultsModel()
        )
    }
    
}
