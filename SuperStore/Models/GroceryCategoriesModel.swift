//
//  GroceryModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

struct GrandParentCategoryModel {
    var id: Int
    var name:String
    var childCategories: [ParentCategoryModel]
    
    func getRealmObject() -> GrandParentCategoryHistory {
        let category = GrandParentCategoryHistory()
        category.id = self.id
        category.name = self.name
        
        let categories = List<ParentCategoryHistory>()
        
        for category in self.childCategories {
            categories.append(category.getRealmObject())
        }
        
        category.childCategories = categories
        
        return category
    }
}

struct ParentCategoryModel {
    var id: Int
    var name:String
    var parentCategoryId: Int
    var childCategories: [ChildCategoryModel]
    
    func getRealmObject() -> ParentCategoryHistory {
        let category = ParentCategoryHistory()
        category.id = self.id
        category.name = self.name
        
        category.parentCategoryId = self.parentCategoryId
        let categories = List<ChildCategoryHistory>()
        
        for category in self.childCategories {
            categories.append(category.getRealmObject())
        }
        
        category.childCategories = categories
        
        return category
    }
}


struct ChildCategoryModel {
    var id: Int
    var name:String
    var parentCategoryId: Int
    var products: [ProductModel]
    
    func getRealmObject() -> ChildCategoryHistory {
        let category = ChildCategoryHistory()
        category.id = self.id
        category.name = self.name
        
        let productList = List<ProductHistory>()
        
        let realm = try? Realm()
        
        for product in self.products {
            if let productItem = realm?.objects(ProductHistory.self).filter("id = \(product.id)").first {
                productList.append(productItem)
            } else {
                productList.append(product.getRealmObject())
            }
        }
        
        category.parentCategoryId = self.parentCategoryId
        category.products = productList
        
        return category
    }
}
