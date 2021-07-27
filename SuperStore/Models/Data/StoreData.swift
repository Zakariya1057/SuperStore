//
//  StoreData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct StoresDataResponse: Decodable {
    var data: [StoreData]
}

struct StoreDataResponse: Decodable {
    var data: StoreData
}

struct StoreData: Decodable {
    var id: Int
    var supermarket_chain_id: Int
    let name: String
    let opening_hours: [OpeningHoursData]?
    var location: LocationData
    var facilities: [FacilityData]?
    
    func getStoreModel() -> StoreModel {

        let addressItems = [location.address_line1, location.address_line2, location.address_line3, location.city ]
        let address = addressItems.compactMap { $0 }.joined(separator: ", ")
        
        return StoreModel(
            id: id,
            name: name,
            address: address,
            
            openingHours: opening_hours?.map({ (hour: OpeningHoursData) in
                return hour.getOpeningHourModel(storeID: id)
            }) ?? [],
            
            location: location.getLocationModel(storeID: id),
            
            facilities: facilities?.map({ (facility: FacilityData) in
                return facility.name
            }) ?? [],
            
            supermarketChainID: supermarket_chain_id
        )
    }
}

struct OpeningHoursData: Decodable {
    let opens_at:String?
    let closes_at:String?
    let closed_today:Bool?
    let day_of_week:Int
    
    func getOpeningHourModel(storeID: Int) -> OpeningHourModel {
        return OpeningHourModel(
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
    
    var latitude: Double?
    var longitude: Double?
    
    var region_id: Int
    
    func getLocationModel(storeID: Int) -> LocationModel {
        return LocationModel(
            storeID: storeID,
            
            regionID: region_id,
            
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
