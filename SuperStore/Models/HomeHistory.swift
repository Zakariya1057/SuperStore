//
//  HomeHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 18/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class HomeHistory: Object {
    var lists = List<ListHistory>()
    var stores = List<StoreHistory>()
    var featured = List<ProductHistory>()
    var groceries = List<ProductHistory>()
    var monitoring = List<ProductHistory>()
    var promotions = List<PromotionHistory>()
    var categories = List<ChildCategoryHistory>()
    
    func getHomeModel() -> HomeModel {
        var listItems: [ListModel] = []
        var storeItems: [StoreModel] = []
        var featureItems: [ProductModel] = []
        var groceryItems: [ProductModel] = []
        var promotionItems: [PromotionModel] = []
        var monotiringItems: [ProductModel] = []
        var categoryItems: [String: [ProductModel]] = [:]
        
//        for list in self.list {
//            listItems.append(list.)
//        }
        
        return HomeModel(
            lists: listItems, stores: storeItems,
            featured: featureItems, groceries: groceryItems,
            monitoring: monotiringItems, promotions: promotionItems,
            categories: categoryItems
        )
    }
    
}
