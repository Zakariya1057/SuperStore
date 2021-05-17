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

    func getCategoryObject(category: GrandParentCategoryModel) -> GrandParentCategoryObject? {
        return realm?.objects(GrandParentCategoryObject.self).filter("id = %@", category.id).first
    }
    
    func getCategoryObject(category: ParentCategoryModel) -> ParentCategoryObject? {
        return realm?.objects(ParentCategoryObject.self).filter("id = %@", category.id).first
    }
    
    func getCategoryObject(category: ChildCategoryModel) -> ChildCategoryObject? {
        return realm?.objects(ChildCategoryObject.self).filter("id = %@", category.id).first
    }
    
    func getAllGrandParentCategoriesByStoreType(storeTypeID: Int) -> Results<GrandParentCategoryObject>? {
        return realm?.objects(GrandParentCategoryObject.self).filter("storeTypeID = %@", storeTypeID)
    }
    
    func getAllChildCategoriesByStoreType(storeTypeID: Int) -> Results<ChildCategoryObject>? {
        return realm?.objects(ChildCategoryObject.self).filter("storeTypeID = %@", storeTypeID)
    }

    func createCategories(categories: [GrandParentCategoryModel]) {
        if let storeTypeID = categories.first?.storeTypeID {
            disableAllGrandParentCategories(storeTypeID: storeTypeID)
        }

        for category in categories {
            createCategory(category: category)
        }
    }
    
    func createCategories(categories: [ChildCategoryModel]) {
        if let storeTypeID = categories.first?.storeTypeID {
            disableAllChildCategories(storeTypeID: storeTypeID)
        }

        for category in categories {
            createCategory(category: category)
        }
    }
    
    func getGrandParentCategories(storeTypeID: Int) -> [GrandParentCategoryModel] {
        // Only get grand parent and direct children only. No products
        var categories: [GrandParentCategoryModel] = []
        
        let savedCategories = realm?
            .objects(GrandParentCategoryObject.self).filter("enabled = true AND storeTypeID = %@", storeTypeID)
            .sorted(byKeyPath: "index", ascending: true)
        
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
        
        let savedCategories = realm?
            .objects(ChildCategoryObject.self).filter("enabled = true AND parentCategoryID = %@", parentCategoryID)
            .sorted(byKeyPath: "index", ascending: true)
        
        if let savedCategories = savedCategories {
            for category in savedCategories {
                let savedCategory = category.getChildCategoryModel()
                categories.append(savedCategory)
            }
        }
        
        return categories
    }
    
    func getCategoryProducts(childCategoryID: Int) -> ChildCategoryModel? {
        return realm?.objects(ChildCategoryObject.self).filter("enabled = true AND id = %@", childCategoryID).first?.getChildCategoryModel()
    }
}

extension GroceryRealmStore {
    private func disableAllGrandParentCategories(storeTypeID: Int){
        if let savedCategories = getAllGrandParentCategoriesByStoreType(storeTypeID: storeTypeID) {
            for savedCategory in savedCategories {
                try? realm?.write({
                    savedCategory.enabled = false
                })
            }
        }
    }
    
    private func disableAllChildCategories(storeTypeID: Int){
        if let savedCategories = getAllChildCategoriesByStoreType(storeTypeID: storeTypeID) {
            for savedCategory in savedCategories {
                try? realm?.write({
                    savedCategory.enabled = false
                })
            }
        }
    }
}

extension GroceryRealmStore {
    func createCategory(category: GrandParentCategoryModel){
        if let savedCategory = getCategoryObject(category: category) {
            updateGrandParentCategory(category: category, savedCategory: savedCategory)
        } else {
            try? realm?.write({
                let savedCategory = createCategoryObject(category: category)
                realm?.add(savedCategory)
            })
        }
    }
    
    func createCategory(category: ParentCategoryModel){
        if let savedCategory = getCategoryObject(category: category) {
            updateParentCategory(category: category, savedCategory: savedCategory)
        } else {
            try? realm?.write({
                let savedCategory = createCategoryObject(category: category)
                realm?.add(savedCategory)
            })
        }
    }
    
    func createCategory(category: ChildCategoryModel){
        if let savedCategory = getCategoryObject(category: category) {
            updateChildCategory(category: category, savedCategory: savedCategory)
        } else {
            try? realm?.write({
                let savedCategory = createCategoryObject(category: category)
                realm?.add(savedCategory)
            })
        }
    }
}

extension GroceryRealmStore {
    func createCategoryObject(category: ChildCategoryModel) -> ChildCategoryObject {
        
        if let savedCategory = getCategoryObject(category: category){
            return savedCategory
        }
        
        let savedCategory = ChildCategoryObject()
        
        savedCategory.id = category.id
        savedCategory.name = category.name
        savedCategory.index = category.index
        
        savedCategory.storeTypeID = category.storeTypeID
        savedCategory.parentCategoryID = category.parentCategoryID
        
        savedCategory.enabled = true
        
        if let realm = realm, realm.isInWriteTransaction {
            realm.add(savedCategory)
        } else {
            try? realm?.write({
                realm?.add(savedCategory)
            })
        }

        for product in category.products {
            let savedProduct = productStore.createProductObject(product: product)
            savedCategory.products.append(savedProduct)
        }
        
        return savedCategory
    }
    
    func createCategoryObject(category: ParentCategoryModel) -> ParentCategoryObject {
        
        if let savedCategory = getCategoryObject(category: category){
            return savedCategory
        }
        
        let savedCategory = ParentCategoryObject()
        
        savedCategory.id = category.id
        savedCategory.name = category.name
        savedCategory.index = category.index
        
        savedCategory.storeTypeID = category.storeTypeID
        
        savedCategory.enabled = true
        
        for categoryItem in category.childCategories {
            let savedChildCategory = createCategoryObject(category: categoryItem)
            savedCategory.childCategories.append(savedChildCategory)
        }
        
        return savedCategory
    }
    
    func createCategoryObject(category: GrandParentCategoryModel) -> GrandParentCategoryObject {
        
        if let savedCategory = getCategoryObject(category: category){
            return savedCategory
        }
        
        let savedCategory = GrandParentCategoryObject()
        
        savedCategory.id = category.id
        savedCategory.name = category.name
        savedCategory.index = category.index
        
        savedCategory.storeTypeID = category.storeTypeID
        
        savedCategory.enabled = true
        
        for category in category.parentCategories {
            let savedChildCategory = createCategoryObject(category: category)
            savedCategory.parentCategories.append(savedChildCategory)
        }
        
        return savedCategory
    }
}

extension GroceryRealmStore {
    func updateGrandParentCategory(category: GrandParentCategoryModel, savedCategory: GrandParentCategoryObject){
        try? realm?.write({
            savedCategory.name = category.name
            savedCategory.enabled = true
            savedCategory.index = category.index
            
            savedCategory.updatedAt = Date()
            
            savedCategory.parentCategories.removeAll()
            
            for category in category.parentCategories {
                savedCategory.parentCategories.append( createCategoryObject(category: category) )
            }
        })
    }
    
    func updateParentCategory(category: ParentCategoryModel, savedCategory: ParentCategoryObject){
        try? realm?.write({
            savedCategory.name = category.name
            savedCategory.enabled = true
            savedCategory.index = category.index
            
            savedCategory.updatedAt = Date()
            
            savedCategory.childCategories.removeAll()
            
            for categoryItem in category.childCategories {
                savedCategory.childCategories.append( createCategoryObject(category: categoryItem) )
            }
        })
    }
    
    func updateChildCategory(category: ChildCategoryModel, savedCategory: ChildCategoryObject){
        try? realm?.write({
            savedCategory.name = category.name
            savedCategory.enabled = true
            savedCategory.index = category.index
            
            savedCategory.updatedAt = Date()
            
            savedCategory.products.removeAll()
            
            for product in category.products {
                savedCategory.products.append( productStore.createProductObject(product: product) )
            }
        })
    }
}
