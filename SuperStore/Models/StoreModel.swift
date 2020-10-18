//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

struct StoreModel {
    var id: Int
    var name: String
    var logo: String
    var opening_hours: [OpeningHoursModel]
    var location: LocationModel
    var facilities: [String]
    var store_type_id: Int
    
    func getRealmObject() -> StoreHistory {
        let store = StoreHistory()
        
        store.id = self.id
        store.name = self.name
        store.logo = self.logo
        
        let storeHours = List<OpeningHoursHistory>()
        let storeFacilities = List<String>()
       
        
        for facility in facilities {
            storeFacilities.append(facility)
        }
        
        for hour in self.opening_hours {
            storeHours.append(hour.getRealmObject())
        }
        
        store.opening_hours = storeHours
        store.facilities = storeFacilities

        store.location = self.location.getRealmObject()
        
        return store
    }
}

struct OpeningHoursModel {
    let store_id: Int
    
    let opens_at:String
    let closes_at:String
    let closed_today:Bool
    let day_of_week:Int
    
    func getRealmObject() -> OpeningHoursHistory {
        let hour = OpeningHoursHistory()
        
        hour.opens_at = self.opens_at
        hour.closes_at = self.closes_at
        hour.day_of_week = self.day_of_week
        hour.closed_today = self.closed_today
        hour.store_id = self.store_id
        
        return hour
    }
}

struct LocationModel:Decodable {
    let store_id: Int
    
    let city: String
    let address_line1: String
    let address_line2: String?
    let address_line3: String?
    let postcode: String
    
    var latitude: Double
    var longitude: Double
    
    func getRealmObject() -> LocationHistory {
        let location = LocationHistory()
        location.city = self.city
        location.address_line1 = self.address_line1
        location.address_line2 = self.address_line2
        location.address_line3 = self.address_line3
        
        location.latitude = self.latitude
        location.longitude = self.longitude
        
        return location
    }
}
