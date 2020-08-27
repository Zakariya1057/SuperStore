//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct StoreModel {
    var name: String
    var logo: String
    var opening_hours: [OpeningHoursModel]
    var location: LocationModel
    var facilities: [String]
}

struct OpeningHoursModel {
    let opens_at:String
    let closes_at:String
    let closed_today:Bool?
    let day_of_week:Int
}

struct LocationModel:Decodable {
    let city: String
    let address_line1: String
    let address_line2: String?
    let address_line3: String?
    let postcode: String
}
