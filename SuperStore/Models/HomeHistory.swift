////
////  HomeHistory.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 18/10/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//class HomeHistory: Object {
//    var lists = List<ListHistory>()
//    var stores = List<StoreHistory>()
//    var featured = List<ProductHistory>()
//    var groceries = List<ProductHistory>()
//    var promotions = List<PromotionHistory>()
//    var categories = List<FeaturedCategory>()
//    
//    func getHomeModel() -> HomeModel {
//        
//        let realm = try! Realm()
//        
//        let listItems: [ListModel] = self.lists.map{ $0.getListModel() }
//        let storeItems: [StoreModel] = self.stores.map{ $0.getStoreModel() }
//        let featureItems: [ProductModel] = self.featured.map{ $0.getProductModel() }
//        let groceryItems: [ProductModel] = self.groceries.map{ $0.getProductModel() }
//        let promotionItems: [PromotionModel] = self.promotions.map{ $0.getPromotionModel() }
//        let monotiringItems: [ProductModel] = realm.objects(ProductHistory.self).filter("monitoring = true").map{ $0.getProductModel() }
//        
//        var categoryItems: [String: [ProductModel]] = [:]
//        
//        for category in self.categories.sorted(byKeyPath: "name", ascending: true) {
//            categoryItems[category.name] = category.products.map({ $0.getProductModel() })
//        }
//        
//        return HomeModel(
//            lists: listItems, stores: storeItems,
//            featured: featureItems, groceries: groceryItems,
//            monitoring: monotiringItems, promotions: promotionItems,
//            categories: categoryItems
//        )
//    }
//    
//}
//
//class FeaturedCategory: Object {
//    @objc dynamic var name: String = ""
//    var products = List<ProductHistory>()
//}
