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
    
    var parentCategories = List<ParentCategoryObject>()
    
    func getGrandParentCategoryModel() -> GrandParentCategoryModel {
        return GrandParentCategoryModel(
            id: id,
            name: name,
            storeTypeID: storeTypeID,
            parentCategories: parentCategories.map{ $0.getParentCategoryModel() })
    }
}

class ParentCategoryObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name:String = ""
    @objc dynamic var storeTypeID: Int = 1
    
    @objc dynamic var grandParentCategoryID: Int = 1
    
    var childCategories = List<ChildCategoryObject>()
    
    func getParentCategoryModel() -> ParentCategoryModel {
        return ParentCategoryModel(
            id: id,
            name: name,
            grandParentCategoryID: grandParentCategoryID,
            storeTypeID: storeTypeID,
            childCategories: childCategories.map{ $0.getChildCategoryModel() }
        )
    }
}

class ChildCategoryObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name:String = ""
    @objc dynamic var storeTypeID: Int = 1
    
    @objc dynamic var parentCategoryID: Int = 1
    
    var products = List<ProductObject>()
    
    func getChildCategoryModel() -> ChildCategoryModel {
        return ChildCategoryModel(
            id: id,
            name: name,
            parentCategoryID: parentCategoryID,
            storeTypeID: storeTypeID,
            products: products.map{ $0.getProductModel() }
        )
    }
}
