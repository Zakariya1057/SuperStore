//
//  ListModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ListModel {
    var id: Int
    var name: String
    var createdAt: Date
    var status: ListStatus
    var identifier: String
    var storeTypeID: Int?
    var userID: Int
    var totalPrice: Double
    var oldTotalPrice: Double?
    var categories: [ListCategoryModel]
    var totalItems: Int
    var tickedOffItems: Int}

struct ListCategoryModel {
    var id: Int
    var name: String
    var aisleName: String?
    var items: [ListItemModel]
    var listID: Int
}

struct ListItemModel {
    var id: Int
    var tickedOff: Bool
    var listID: Int
}

enum ListStatus: String {
    case completed
    case inProgress
    case notStarted
}
