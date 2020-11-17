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
    var openingHours: [OpeningHoursModel]
    var location: LocationModel
    var facilities: [String]
    var storeTypeID: Int
    
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
        
        for hour in self.openingHours {
            storeHours.append(hour.getRealmObject())
        }
        
        store.openingHours = storeHours
        store.facilities = storeFacilities
        store.storeTypeID = storeTypeID

        store.location = self.location.getRealmObject()
        
        return store
    }
}

struct OpeningHoursModel {
    let storeID: Int
    
    let opensAt:String?
    let closesAt:String?
    let closedToday:Bool
    let dayOfWeek:Int
    
    func getRealmObject() -> OpeningHoursHistory {
        let hour = OpeningHoursHistory()
        
        hour.opensAt = self.opensAt
        hour.closesAt = self.closesAt
        hour.dayOfWeek = self.dayOfWeek
        hour.closedToday = self.closedToday
        hour.storeID = self.storeID
        
        return hour
    }
}

struct LocationModel:Decodable {
    let storeID: Int
    
    let city: String
    let addressLine1: String
    let addressLine2: String?
    let addressLine3: String?
    let postcode: String
    
    var latitude: Double
    var longitude: Double
    
    func getRealmObject() -> LocationHistory {
        let location = LocationHistory()
        location.city = self.city
        location.addressLine1 = self.addressLine1
        location.addressLine2 = self.addressLine2
        location.addressLine3 = self.addressLine3
        
        location.latitude = self.latitude
        location.longitude = self.longitude
        
        return location
    }
}
