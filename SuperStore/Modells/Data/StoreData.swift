//
//  StoreData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct StoreDataResponse: Decodable {
    var data: StoreData
}

struct StoreData: Decodable {
    var id: Int
    var store_type_id: Int
    let name: String
    var small_logo: String
    var large_logo: String
    let opening_hours: [OpeningHoursData]?
    var location: LocationData
    var facilities: [FacilityData]?
    
    func getStoreModel() -> StoreModel {
        return StoreModel(
            id: id,
            name: name,
            logo: small_logo,
            openingHours: opening_hours?.map({ (hour: OpeningHoursData) in
                return hour.getOpeningHourModel(storeID: id)
            }) ?? [],
            location: location.getLocationModel(storeID: id),
            facilities: facilities?.map({ (facility: FacilityData) in
                return facility.name
            }) ?? [],
            storeTypeID: store_type_id
        )
    }
}

struct OpeningHoursData: Decodable {
    let opens_at:String?
    let closes_at:String?
    let closed_today:Bool?
    let day_of_week:Int
    
    func getOpeningHourModel(storeID: Int) -> OpeningHoursModel {
        return OpeningHoursModel(
            storeID: storeID,
            opensAt: opens_at,
            closesAt: closes_at,
            closedToday: closed_today ?? true,
            dayOfWeek: day_of_week
        )
    }
}

struct LocationData:Decodable {
    let city: String
    let address_line1: String
    let address_line2: String?
    let address_line3: String?
    let postcode: String
    
    var latitude: Double
    var longitude: Double
    
    func getLocationModel(storeID: Int) -> LocationModel {
        return LocationModel(
            storeID: storeID,
            city: city,
            addressLine1: address_line1,
            addressLine2: address_line2,
            addressLine3: address_line3,
            postcode: postcode,
            latitude: latitude,
            longitude: longitude
        )
    }
}

struct FacilityData: Decodable {
    let name:String
}
