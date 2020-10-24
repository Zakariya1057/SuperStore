//
//  HomeData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct HomeResponseData: Decodable {
    var data: HomeData
}

struct HomeData:Decodable {
    var lists: [ListData]?
    var stores: [StoreData]?
    var featured: [ProductData]?
    var groceries: [ProductData]?
    var monitoring: [ProductData]?
    var promotions: [PromotionData]?
    var categories: [String: [ProductData]]?
}
