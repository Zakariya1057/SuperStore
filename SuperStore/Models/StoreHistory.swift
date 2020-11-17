//
//  StoreHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 14/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class StoreHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var logo: String = ""
    @objc dynamic var storeTypeID: Int = 1
   
    @objc dynamic var location: LocationHistory?
    var openingHours = List<OpeningHoursHistory>()
    
    var facilities = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["storeTypeID"]
    }
    
    func getStoreModel() -> StoreModel {
        var hours: [OpeningHoursModel] = []
        
        for hour in self.openingHours {
            hours.append( hour.getHourModel() )
        }
        
        return StoreModel(id: self.id, name: self.name, logo: self.logo, openingHours: hours, location: self.location!.getLocationModel(), facilities: self.facilities.map{ "\($0)"}, storeTypeID: self.storeTypeID)
    }
}

class OpeningHoursHistory: Object {
    @objc dynamic var opensAt: String? = nil
    @objc dynamic var closesAt: String? = nil
    @objc dynamic var closedToday: Bool = false
    @objc dynamic var dayOfWeek: Int = 1
    @objc dynamic var storeID: Int = 1
    
    func getHourModel() -> OpeningHoursModel {
        return OpeningHoursModel(storeID: self.storeID, opensAt: self.opensAt, closesAt: self.closesAt, closedToday: self.closedToday, dayOfWeek: self.dayOfWeek)
    }
}

class LocationHistory: Object {
    @objc dynamic var city: String = ""
    @objc dynamic var addressLine1: String = ""
    @objc dynamic var addressLine2: String? = nil
    @objc dynamic var addressLine3: String? = nil
    @objc dynamic var postcode: String = ""
    
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    @objc dynamic var storeID: Int = 1
    
    func getLocationModel() -> LocationModel {
        return LocationModel(storeID: self.storeID, city: self.city, addressLine1: self.addressLine1, addressLine2: self.addressLine2, addressLine3: self.addressLine3, postcode: self.postcode, latitude: self.latitude, longitude: self.longitude)
    }
}
