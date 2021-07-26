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
    
    func getHomeObject(supermarketChainID: Int) -> HomeObject? {
        return realm?.objects(HomeObject.self).filter("supermarketChainID = %@", supermarketChainID).first
    }
    
    var productStore: ProductStoreProtocol = ProductRealmStore()
    var storeStore: StoreStoreProtocol = StoreRealmStore()
    var listStore: ListStoreProtocol = ListRealmStore()
    var categoryStore: GroceryStoreProtocol = GroceryRealmStore()
    var promotionStore: PromotionStoreProtocol = PromotionRealmStore()
    var messageStore: MessageStoreProtocol = MessageRealmStore()
    
    func createHome(supermarketChainID: Int, home: HomeModel){

        try? realm?.write({
            
            let savedHome = HomeObject()
            savedHome.supermarketChainID = supermarketChainID
            
            if let savedHome = getHomeObject(supermarketChainID: supermarketChainID) {
                realm?.delete(savedHome)
            }
            
            realm?.add(savedHome)
            
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
            
            savedHome.promotions.removeAll()
            for promotion in home.promotions {
                let savedPromotion = promotionStore.createPromotionObject(promotion: promotion)
                savedHome.promotions.append(savedPromotion)
            }

            savedHome.categories.removeAll()
            for category in home.categories {
                let savedCategory =  categoryStore.createCategoryObject(category: category)
                savedHome.categories.append(savedCategory)
            }

        })
        
        messageStore.saveMessages(messages: home.messages)
    }
    
    func getHome(supermarketChainID: Int) -> HomeModel? {
        
        let savedHome = getHomeObject(supermarketChainID: supermarketChainID)
        
        if savedHome == nil {
            return nil
        }
        
        let listLimit: Int = 4
        let storeLimit: Int = 20
        
        let lists: [ListModel] = getLists(supermarketChainID: supermarketChainID, limit: listLimit)
        let stores: [StoreModel] = getStores(supermarketChainID: supermarketChainID, limit: storeLimit)
        let featured: [ProductModel] = getProducts(supermarketChainID: supermarketChainID, savedProducts: savedHome?.featured)
        let groceries: [ProductModel] = getProducts(supermarketChainID: supermarketChainID, savedProducts: savedHome?.groceries)
        let monitoring: [ProductModel] = getProducts(supermarketChainID: supermarketChainID, savedProducts: savedHome?.monitoring)
        let promotions: [PromotionModel] = getPromotions(supermarketChainID: supermarketChainID, savedHome: savedHome)
        let categories: [ChildCategoryModel] = getCategories(supermarketChainID: supermarketChainID, savedHome: savedHome)
        
        return HomeModel(
            lists: lists,
            stores: stores,
            featured: featured,
            groceries: groceries,
            monitoring: monitoring,
            promotions: promotions,
            categories: categories,
            messages: []
        )
        
    }
    
}

extension HomeRealmStore {
    private func getLists(supermarketChainID: Int, limit: Int) -> [ListModel] {
        
        let savedLists = realm?.objects(ListObject.self)
            .filter("deleted = false")
        
        var lists: [ListModel] = []
        
        if let savedLists = savedLists, savedLists.count > 0 {
            let savedCount = savedLists.count
            let maxItems = savedCount < limit ? savedCount : limit
            
            let sortedList = savedLists.sorted(by: { (a: ListObject, b:ListObject) -> Bool in
                let progressA = a.tickedOffItems > 0 && a.totalItems > 0 ? Float(a.tickedOffItems) / Float(a.totalItems) : 0
                let progressB = b.tickedOffItems > 0 && b.totalItems > 0 ? Float(b.tickedOffItems) / Float(b.totalItems) : 0
                
                return progressA > progressB
            })
            
            for index in 0...maxItems - 1{
                lists.append( sortedList[index].getListModel() )
            }
        }
        
        return lists
    }
    
    func getStores(supermarketChainID: Int, limit: Int) -> [StoreModel] {
        let savedStores = realm?.objects(StoreObject.self)
            .filter("supermarketChainID = %@", supermarketChainID)
            .sorted(byKeyPath: "updatedAt", ascending: true)
        
        var stores: [StoreModel] = []
        
        if let savedStores = savedStores, savedStores.count > 0 {
            let savedCount = savedStores.count
            let maxItems = savedCount < limit ? savedCount : limit
            
            for index in 0...maxItems - 1 {
                stores.append( savedStores[index].getStoreModel() )
            }
        }
        
        return stores
    }
    
    func getProducts(supermarketChainID: Int, savedProducts: List<ProductObject>?) -> [ProductModel]{
        var products: [ProductModel] = []
        
        if let savedProducts = savedProducts, savedProducts.count > 0 {
            savedProducts.forEach { (product: ProductObject) in
                if let productModel = product.getProductModel() {
                    products.append(productModel)
                }
            }
        }
        
        return products
    }
    
    func getPromotions(supermarketChainID: Int, savedHome: HomeObject?) -> [PromotionModel]{
        var promotions: [PromotionModel] = []
        
        if let savedPromotions = savedHome?.promotions.filter("supermarketChainID = %@", supermarketChainID) {
            savedPromotions.forEach { (promotion: PromotionObject) in
                let promotionModel = promotion.getPromotionModel()
                
                if !promotionStore.promotionExpired(promotion: promotionModel){
                    promotions.append( promotionModel )
                }
                
            }
        }
        
        return promotions
    }
    
    func getCategories(supermarketChainID: Int, savedHome: HomeObject?) -> [ChildCategoryModel] {
        var categories: [ChildCategoryModel] = []
        
        if let savedCategories = savedHome?.categories.filter("companyID = %@", supermarketChainID) {
            savedCategories.forEach { (category: ChildCategoryObject) in
                categories.append( category.getChildCategoryModel() )
            }
        }
        
        return categories
    }
}
