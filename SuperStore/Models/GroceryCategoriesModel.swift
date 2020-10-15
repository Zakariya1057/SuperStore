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
    var child_categories: [ParentCategoryModel]
    
    func getRealmObject() -> GrandParentCategoryHistory {
        let category = GrandParentCategoryHistory()
        category.id = self.id
        category.name = self.name
        
        let categories = List<ParentCategoryHistory>()
        
        for category in self.child_categories {
            categories.append(category.getRealmObject())
        }
        
        category.child_categories = categories
        
        return category
    }
}

struct ParentCategoryModel {
    var id: Int
    var name:String
    var child_categories: [ChildCategoryModel]
    
    func getRealmObject() -> ParentCategoryHistory {
        let category = ParentCategoryHistory()
        category.id = self.id
        category.name = self.name
        
        let categories = List<ChildCategoryHistory>()
        
        for category in self.child_categories {
            categories.append(category.getRealmObject())
        }
        
        category.child_categories = categories
        
        return category
    }
}


struct ChildCategoryModel {
    var id: Int
    var name:String
    var products: [ProductModel]
    
    func getRealmObject() -> ChildCategoryHistory {
        let category = ChildCategoryHistory()
        category.id = self.id
        category.name = self.name
        
        let productList = List<ProductHistory>()
        
        for product in self.products {
            productList.append(product.getRealmObject())
        }
        
        category.products = productList
        
        return category
    }
}
