//
//  HomeModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct HomeModel {
    var lists: [ListModel]
    var stores: [StoreModel]
    var featured: [ProductModel]
    var groceries: [ProductModel]
    var monitoring: [ProductModel]
    var promotions: [PromotionModel]
    var categories: [String: [ProductModel]]
    
    func getRealmObject() -> HomeHistory {
        let home = HomeHistory()
        
        self.lists.forEach({ home.lists.append( $0.getRealmObject() )})
        self.stores.forEach({ home.stores.append( $0.getRealmObject() )})
        
        self.featured.forEach({ home.featured.append( $0.getRealmObject() )})
        self.groceries.forEach({ home.groceries.append( $0.getRealmObject() )})
        self.monitoring.forEach({ home.monitoring.append( $0.getRealmObject() )})
        self.promotions.forEach({ home.promotions.append( $0.getRealmObject() )})
        
        for category in self.categories {
            let categoryItem = FeaturedCategory()
            categoryItem.name = category.key
            category.value.forEach({ categoryItem.products.append($0.getRealmObject()) })
            home.categories.append(categoryItem)
        }
        
        return home
    }
}
