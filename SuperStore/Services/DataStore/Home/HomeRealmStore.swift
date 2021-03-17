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
    
    var homeObject: HomeObject? {
        return realm?.objects(HomeObject.self).first
    }
    
    var productStore: ProductStoreProtocol = ProductRealmStore()
    var storeStore: StoreStoreProtocol = StoreRealmStore()
    var listStore: ListStoreProtocol = ListRealmStore()
    var categoryStore: GroceryStoreProtocol = GroceryRealmStore()
    var promotionStore: PromotionStoreProtocol = PromotionRealmStore()
    
    func createHome(storeTypeID: Int, home: HomeModel){
        
        try? realm?.write({
            
            if let savedHome = homeObject {
                realm?.delete(savedHome)
            }
            
            let savedHome = HomeObject()
            
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
            
            savedHome.on_sale.removeAll()
            for savedProduct in home.on_sale.map({ productStore.createProductObject(product: $0) }) {
                savedHome.on_sale.append(savedProduct)
            }
            
            savedHome.stores.removeAll()
            for savedStore in home.stores.map({ storeStore.createStoreObject(store: $0 ) }){
                savedHome.stores.append(savedStore)
            }
            
            savedHome.lists.removeAll()
            for savedList in home.lists.map({ listStore.createListObject(list: $0, ignoreCategories: true)} ){
                savedHome.lists.append(savedList)
            }
            
            savedHome.promotions.removeAll()
            for savedPromotion in home.promotions.map({ promotionStore.createPromotionObject(promotion: $0)}){
                savedHome.promotions.append(savedPromotion)
            }
            
            savedHome.categories.removeAll()
            let savedCagegories = home.categories.map({ categoryStore.createCategoryObject(category: $0) })
            
            for savedCategory in savedCagegories {
                savedHome.categories.append(savedCategory)
            }
            
            realm?.add(savedHome)
        })
    }
    
    func getHome() -> HomeModel? {
        
        if homeObject == nil {
            return nil
        }
        
        let listLimit: Int = 4
        let storeLimit: Int = 10
        
        let lists: [ListModel] = getLists(limit: listLimit)
        let stores: [StoreModel] = getStores(limit: storeLimit)
        let featured: [ProductModel] = getProducts(savedProducts: homeObject?.featured)
        let groceries: [ProductModel] = getProducts(savedProducts: homeObject?.groceries)
        let monitoring: [ProductModel] = getProducts(savedProducts: homeObject?.monitoring)
        let on_sale: [ProductModel] = getProducts(savedProducts: homeObject?.on_sale)
        let promotions: [PromotionModel] = getPromotions()
        let categories: [ChildCategoryModel] = getCategories()
        
        return HomeModel(
            lists: lists,
            stores: stores,
            featured: featured,
            groceries: groceries,
            monitoring: monitoring,
            promotions: promotions,
            on_sale: on_sale,
            categories: categories
        )
        
    }

}

extension HomeRealmStore {
    private func getLists(limit: Int) -> [ListModel] {
        let savedLists = realm?.objects(ListObject.self).sorted(byKeyPath: "updatedAt", ascending: true)
        var lists: [ListModel] = []
        
        if let savedLists = savedLists, savedLists.count > 0 {
            let savedCount = savedLists.count
            let maxItems = savedCount < limit ? savedCount - 1 : limit
            
            for index in 0...maxItems {
                lists.append( savedLists[index].getListModel() )
            }
        }
        
        return lists
    }
    
    func getStores(limit: Int) -> [StoreModel] {
        let savedStores = realm?.objects(StoreObject.self).sorted(byKeyPath: "updatedAt", ascending: true)
        var stores: [StoreModel] = []
        
        if let savedStores = savedStores, savedStores.count > 0 {
            let savedCount = savedStores.count
            let maxItems = savedCount < limit ? savedCount - 1 : limit
            
            for index in 0...maxItems-1 {
                stores.append( savedStores[index].getStoreModel() )
            }
        }
        
        return stores
    }
    
    func getProducts(savedProducts: List<ProductObject>?) -> [ProductModel]{
        var products: [ProductModel] = []
        
        if let savedProducts = savedProducts, savedProducts.count > 0 {
            savedProducts.forEach { (product: ProductObject) in
                products.append( product.getProductModel() )
            }
        }
        
        return products
    }
    
    func getPromotions() -> [PromotionModel]{
        var promotions: [PromotionModel] = []
        
        if let savedPromotions = homeObject?.promotions {
            savedPromotions.forEach { (promotion: PromotionObject) in
                promotions.append( promotion.getPromotionModel() )
            }
        }
        
        return promotions
    }
    
    func getCategories() -> [ChildCategoryModel] {
        var categories: [ChildCategoryModel] = []
        
        if let savedCategories = homeObject?.categories {
            savedCategories.forEach { (category: ChildCategoryObject) in
                categories.append( category.getChildCategoryModel() )
            }
        }
        
        return categories
    }
}
