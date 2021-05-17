//
//  CategoryObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 11/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class GrandParentCategoryObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var storeTypeID: Int = 1
    
    @objc dynamic var index: Int = 0
    
    var parentCategories = List<ParentCategoryObject>()
    
    @objc dynamic var enabled: Bool = true
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    func getGrandParentCategoryModel() -> GrandParentCategoryModel {
        return GrandParentCategoryModel(
            id: id,
            name: name,
            index: index,
            storeTypeID: storeTypeID,
            parentCategories: parentCategories.map{ $0.getParentCategoryModel() })
    }
    
    
    override static func primaryKey() -> String? {
         return "id"
     }
}

class ParentCategoryObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name:String = ""
    @objc dynamic var storeTypeID: Int = 1
    
    @objc dynamic var index: Int = 0
    
    @objc dynamic var grandParentCategoryID: Int = 1
    
    var childCategories = List<ChildCategoryObject>()
    
    @objc dynamic var enabled: Bool = true
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    func getParentCategoryModel() -> ParentCategoryModel {
        return ParentCategoryModel(
            id: id,
            name: name,
            index: index,
            grandParentCategoryID: grandParentCategoryID,
            storeTypeID: storeTypeID,
            childCategories: childCategories.map{ $0.getChildCategoryModel() }
        )
    }
    
    
    override static func primaryKey() -> String? {
         return "id"
    }
}

class ChildCategoryObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name:String = ""
    @objc dynamic var storeTypeID: Int = 1
    
    @objc dynamic var index: Int = 0
    
    @objc dynamic var parentCategoryID: Int = 1
    
    var products = List<ProductObject>()
    
    @objc dynamic var enabled: Bool = true
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    func getChildCategoryModel() -> ChildCategoryModel {
        return ChildCategoryModel(
            id: id,
            name: name,
            index: index,
            parentCategoryID: parentCategoryID,
            storeTypeID: storeTypeID,
            products: products.map{ $0.getProductModel() }
        )
    }
    
    
    override static func primaryKey() -> String? {
         return "id"
     }
}
