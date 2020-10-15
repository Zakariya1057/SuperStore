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
    @objc dynamic var store_type_id: Int = 1
   
    @objc dynamic var location: LocationHistory?
    var opening_hours = List<OpeningHoursHistory>()
    
    var facilities = List<String>()
    
    func getStoreModel() -> StoreModel {
        var hours: [OpeningHoursModel] = []
        
        for hour in self.opening_hours {
            hours.append( hour.getHourModel() )
        }
        
        return StoreModel(id: self.id, name: self.name, logo: self.logo, opening_hours: hours, location: self.location!.getLocationModel(), facilities: self.facilities.map{ "\($0)"}, store_type_id: self.store_type_id)
    }
}

class OpeningHoursHistory: Object {
    @objc dynamic var opens_at: String = ""
    @objc dynamic var closes_at: String = ""
    @objc dynamic var closed_today: Bool = false
    @objc dynamic var day_of_week: Int = 1
    
    func getHourModel() -> OpeningHoursModel {
        return OpeningHoursModel(opens_at: self.opens_at, closes_at: self.closes_at, closed_today: self.closed_today, day_of_week: self.day_of_week)
    }
}

class LocationHistory: Object {
    @objc dynamic var city: String = ""
    @objc dynamic var address_line1: String = ""
    @objc dynamic var address_line2: String? = nil
    @objc dynamic var address_line3: String? = nil
    @objc dynamic var postcode: String = ""
    
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    @objc dynamic var store_id: Int = 1
    
    func getLocationModel() -> LocationModel {
        return LocationModel(store_id: self.store_id, city: self.city, address_line1: self.address_line1, address_line2: self.address_line2, address_line3: self.address_line3, postcode: self.postcode, latitude: self.latitude, longitude: self.longitude)
    }
}
