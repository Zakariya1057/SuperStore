//
//  UserModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct UserModel {
    var id: Int
    var name: String
    var token: String
    var email: String
    var storeTypeID: Int
    var storeName: String?
    var sendNotifications: Bool
}

struct StoreTypeModel {
    var id: Int
    var name: String
    var type: StoreType
}

enum StoreType: String {
    case asda = "Asda"
    case realCanadianSuperstore = "Real Canadian Superstore"
}
