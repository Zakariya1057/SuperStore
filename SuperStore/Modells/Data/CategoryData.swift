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

struct GrandParentCategoryData:Decodable {
    var id: Int
    var name: String
    var parent_categories: [ParentCategoryData]
    
    func getParentCategoryModel() -> GrandParentCategoryModel {
        return GrandParentCategoryModel(id: id, name: name, parentCategories: parent_categories.map { $0.getParentCategoryModel() })
    }
}

struct ParentCategoryData:Decodable {
    var id: Int
    var name: String
    var child_categories: [ChildCategoryData]?
    
    func getParentCategoryModel() -> ParentCategoryModel {
        return ParentCategoryModel(id: id, name: name, childCategories: (child_categories ?? []).map { $0.getChildCategoryModel() })
    }
}

struct ChildCategoryData:Decodable {
    var id: Int
    var name: String
    var products: [ProductData]
    
    func getChildCategoryModel() -> ChildCategoryModel {
        return ChildCategoryModel(id: id, name: name, products: products.map{ $0.getProductModel() })
    }
    
}

//struct ChildCategoryData:Decodable {
//    var id: Int
//    var name:String
//    var products: [ProductData]
//
//    func getChildCategoryModel() -> ChildCategoryModel {
////        return ChildCategoryModel(id: id, name: name, parentCategoryId: <#T##Int#>, products: <#T##[ProductModel]#>)
////    }
//}


//struct GroceryProductsResponseData: Decodable {
//    var data: [GroceryProductsData]
//}
//
//struct GrandParentCategory:Decodable {
//    var id: Int
//    var name:String
//    var parent_category_id: Int
//    var products: [ProductData]
//}