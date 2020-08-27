//
//  SeriesData.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct StoreData: Decodable {
    let name: String
    let opening_hours: [OpeningHoursData]
    var small_logo: String
    var location: LocationData
    var facilities: [FacilityData]
}

struct OpeningHoursData: Decodable {
    let opens_at:String
    let closes_at:String
    let closed_today:Bool?
    let day_of_week:Int
}

struct LocationData:Decodable {
    let city: String
    let address_line1: String
    let address_line2: String?
    let address_line3: String?
    let postcode: String
}

struct FacilityData:Decodable {
    let name:String
}
