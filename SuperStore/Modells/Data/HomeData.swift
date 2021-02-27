//
//  HomeResponseData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct HomeResponeData: Decodable {
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
