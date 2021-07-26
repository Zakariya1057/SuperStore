//
//  FlyerModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct FlyerModel {
    var id: Int
    var name: String
    var products: [ProductModel] = []
    var week: String?
    var url: String
    var storeID: Int
    var validFrom: Date
    var validTo: Date
}
