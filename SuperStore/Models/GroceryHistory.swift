//
//  GroceryHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 14/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class GrandParentCategoryHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var store_type_id: Int = 1
    var child_categories = List<ParentCategoryHistory>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["store_type_id"]
    }
    
    func getCategoryModel() -> GrandParentCategoryModel {
        
        var categoriesList:[ParentCategoryModel] = []
        for category in child_categories {
            categoriesList.append(category.getCategoryModel())
        }
        
        return GrandParentCategoryModel(id: self.id, name: self.name, child_categories: categoriesList)
    }
}

class ParentCategoryHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var parentCategoryId: Int = 1
    var childCategories = List<ChildCategoryHistory>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["parentCategoryId"]
    }
    
    func getCategoryModel() -> ParentCategoryModel {
        
        var categoriesList:[ChildCategoryModel] = []
        for category in childCategories {
            categoriesList.append(category.getCategoryModel())
        }
        
        return ParentCategoryModel(id: self.id, name: self.name, parentCategoryId: self.parentCategoryId, child_categories: categoriesList)
    }
}

class ChildCategoryHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var parentCategoryId: Int = 1
    var products = List<ProductHistory>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["parentCategoryId"]
    }
    
    func getCategoryModel() -> ChildCategoryModel {
        var productsList:[ProductModel] = []
        for product in self.products {
            productsList.append(product.getProductModel())
        }
        
        return ChildCategoryModel(id: self.id, name: self.name, parentCategoryId: self.parentCategoryId, products: productsList)
    }
}
