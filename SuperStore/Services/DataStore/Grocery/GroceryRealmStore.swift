//
//  GroceryRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class GroceryRealmStore: DataStore, GroceryStoreProtocol {

    var productStore: ProductRealmStore = ProductRealmStore()

    func createCategories(categories: [GrandParentCategoryModel], storeTypeID: Int) {
        for category in categories {
            createCategory(category: category, storeTypeID: storeTypeID)
        }
    }
    
    func createCategories(categories: [ChildCategoryModel], storeTypeID: Int, parentCategoryID: Int) {
        for category in categories {
            createCategory(category: category, storeTypeID: storeTypeID, parentCategoryID: parentCategoryID)
        }
    }
    
    func getGrandParentCategories(storeTypeID: Int) -> [GrandParentCategoryModel] {
        // Only get grand parent and direct children only. No products
        var categories: [GrandParentCategoryModel] = []
        
        let savedCategories = realm?.objects(GrandParentCategoryObject.self).filter("storeTypeID = %@", storeTypeID)
        
        if let savedCategories = savedCategories {
            for category in savedCategories {
                let savedCategory = category.getGrandParentCategoryModel()
                categories.append(savedCategory)
            }
        }
        
        return categories
    }
    
    func getChildCategories(parentCategoryID: Int) -> [ChildCategoryModel] {
        // Child and products, no recommeneded
        var categories: [ChildCategoryModel] = []
        
        let savedCategories = realm?.objects(ChildCategoryObject.self).filter("parentCategoryID = %@", parentCategoryID)
        
        if let savedCategories = savedCategories {
            for category in savedCategories {
                let savedCategory = category.getChildCategoryModel()
                categories.append(savedCategory)
            }
        }
        
        return categories
    }
}

extension GroceryRealmStore {
    func getCategoryObject(category: GrandParentCategoryModel) -> GrandParentCategoryObject? {
        return realm?.objects(GrandParentCategoryObject.self).filter("id = %@", category.id).first
    }
    
    func getCategoryObject(category: ParentCategoryModel) -> ParentCategoryObject? {
        return realm?.objects(ParentCategoryObject.self).filter("id = %@", category.id).first
    }
    
    func getCategoryObject(category: ChildCategoryModel) -> ChildCategoryObject? {
        return realm?.objects(ChildCategoryObject.self).filter("id = %@", category.id).first
    }
}

extension GroceryRealmStore {
    func createCategory(category: GrandParentCategoryModel, storeTypeID: Int){
        if let savedCategory = getCategoryObject(category: category) {
            updateGrandParentCategory(category: category, savedCategory: savedCategory)
        } else {
            try? realm?.write({
                let savedCategory = createCategoryObject(category: category, storeTypeID: storeTypeID)
                realm?.add(savedCategory)
            })
        }
    }
    
    func createCategory(category: ParentCategoryModel, storeTypeID: Int){
        if let savedCategory = getCategoryObject(category: category) {
            updateParentCategory(category: category, savedCategory: savedCategory)
        } else {
            try? realm?.write({
                let savedCategory = createCategoryObject(category: category, storeTypeID: storeTypeID)
                realm?.add(savedCategory)
            })
        }
    }
    
    func createCategory(category: ChildCategoryModel, storeTypeID: Int, parentCategoryID: Int){
        if let savedCategory = getCategoryObject(category: category) {
            updateChildCategory(category: category, savedCategory: savedCategory)
        } else {
            try? realm?.write({
                let savedCategory = createCategoryObject(category: category, storeTypeID: storeTypeID, parentCategoryID: parentCategoryID)
                realm?.add(savedCategory)
            })
        }
    }
}

extension GroceryRealmStore {
    func createCategoryObject(category: ChildCategoryModel, storeTypeID: Int, parentCategoryID: Int) -> ChildCategoryObject {
        
        if let savedCategory = getCategoryObject(category: category){
            return savedCategory
        }
        
        let savedCategory = ChildCategoryObject()
        
        savedCategory.id = category.id
        savedCategory.name = category.name
        savedCategory.storeTypeID = storeTypeID
        savedCategory.parentCategoryID = parentCategoryID

        for product in category.products {
            let savedProduct = productStore.createProductObject(product: product)
            savedCategory.products.append(savedProduct)
        }
        
        return savedCategory
    }
    
    func createCategoryObject(category: ParentCategoryModel, storeTypeID: Int) -> ParentCategoryObject {
        
        if let savedCategory = getCategoryObject(category: category){
            return savedCategory
        }
        
        let savedCategory = ParentCategoryObject()
        
        savedCategory.id = category.id
        savedCategory.name = category.name
        savedCategory.storeTypeID = storeTypeID
        
        for categoryItem in category.childCategories {
            let savedChildCategory = createCategoryObject(category: categoryItem, storeTypeID: storeTypeID, parentCategoryID: category.id)
            savedCategory.childCategories.append(savedChildCategory)
        }
        
        return savedCategory
    }
    
    func createCategoryObject(category: GrandParentCategoryModel, storeTypeID: Int) -> GrandParentCategoryObject {
        
        if let savedCategory = getCategoryObject(category: category){
            return savedCategory
        }
        
        let savedCategory = GrandParentCategoryObject()
        
        savedCategory.id = category.id
        savedCategory.name = category.name
        savedCategory.storeTypeID = storeTypeID
        
        for category in category.parentCategories {
            let savedChildCategory = createCategoryObject(category: category, storeTypeID: storeTypeID)
            savedCategory.parentCategories.append(savedChildCategory)
        }
        
        return savedCategory
    }
}

extension GroceryRealmStore {
    func updateGrandParentCategory(category: GrandParentCategoryModel, savedCategory: GrandParentCategoryObject){
        try? realm?.write({
            savedCategory.name = category.name
            let storeTypeID: Int = savedCategory.storeTypeID
            
            savedCategory.parentCategories.removeAll()
            
            for category in category.parentCategories {
                savedCategory.parentCategories.append( createCategoryObject(category: category, storeTypeID: storeTypeID) )
            }
        })
    }
    
    func updateParentCategory(category: ParentCategoryModel, savedCategory: ParentCategoryObject){
        try? realm?.write({
            savedCategory.name = category.name
            let storeTypeID: Int = savedCategory.storeTypeID
            
            savedCategory.childCategories.removeAll()
            
            for categoryItem in category.childCategories {
                savedCategory.childCategories.append( createCategoryObject(category: categoryItem, storeTypeID: storeTypeID, parentCategoryID: category.id) )
            }
        })
    }
    
    func updateChildCategory(category: ChildCategoryModel, savedCategory: ChildCategoryObject){
        try? realm?.write({
            savedCategory.name = category.name
            
            savedCategory.products.removeAll()
            
            for product in category.products {
                savedCategory.products.append( productStore.createProductObject(product: product) )
            }
        })
    }
}
