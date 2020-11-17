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
}
