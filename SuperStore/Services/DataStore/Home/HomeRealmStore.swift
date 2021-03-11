//
//  HomeRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 11/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class HomeRealmStore: DataStore, HomeStoreProtocol {
    
    var productStore: ProductStoreProtocol = ProductRealmStore()
    var storeStore: StoreStoreProtocol = StoreRealmStore()
    var listStore: ListStoreProtocol = ListRealmStore()
    var categoryStore: GroceryStoreProtocol = GroceryRealmStore()
    
    func createHome(storeTypeID: Int, home: HomeModel){
        try? realm?.write({
            let savedHome = HomeObject()
            
//            var categories = List<ChildCategoryObject>()
            
            savedHome.featured.removeAll()
            for savedProduct in home.featured.map({ productStore.createProductObject(product: $0) }) {
                savedHome.featured.append(savedProduct)
            }
            
            savedHome.groceries.removeAll()
            for savedProduct in home.groceries.map({ productStore.createProductObject(product: $0) }) {
                savedHome.groceries.append(savedProduct)
            }
            
            savedHome.monitoring.removeAll()
            for savedProduct in home.monitoring.map({ productStore.createProductObject(product: $0) }) {
                savedHome.monitoring.append(savedProduct)
            }
            
            savedHome.stores.removeAll()
            for savedStore in home.stores.map({ storeStore.createStoreObject(store: $0 ) }){
                savedHome.stores.append(savedStore)
            }
            
            savedHome.lists.removeAll()
            for savedList in home.lists.map({ listStore.createListObject(list: $0, ignoreCategories: true)} ){
                savedHome.lists.append(savedList)
            }
            
            savedHome.categories.removeAll()
            let savedCagegories = home.categories.map({ categoryStore.createCategoryObject(category: $0) })
            
            for savedCategory in savedCagegories {
                savedHome.categories.append(savedCategory)
            }
            
            realm?.add(savedHome)
        })
    }

}
