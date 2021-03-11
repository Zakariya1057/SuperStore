//
//  HomeModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct HomeModel {
    var lists: [ListModel]
    var stores: [StoreModel]
    var featured: [ProductModel]
    var groceries: [ProductModel]
    var monitoring: [ProductModel]
    var promotions: [PromotionModel]
    var categories: [ChildCategoryModel]
}
