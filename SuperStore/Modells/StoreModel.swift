//
//  StoreModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct StoreModel {
    var id: Int
    var name: String
    var logo: String
    var openingHours: [OpeningHoursModel]
    var location: LocationModel
    var facilities: [String]
    var storeTypeID: Int
}

struct OpeningHoursModel {
    let storeID: Int

    let opensAt:String?
    let closesAt:String?
    let closedToday:Bool
    let dayOfWeek:Int
}

struct LocationModel {
    let storeID: Int

    let city: String
    let addressLine1: String
    let addressLine2: String?
    let addressLine3: String?
    let postcode: String

    var latitude: Double
    var longitude: Double
}
