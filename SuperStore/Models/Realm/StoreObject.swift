//
//  StoreObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 11/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class StoreObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    
    var facilities = List<String>()
    
    var openingHours = List<OpeningHourObject>()
    @objc dynamic var location: LocationObject?
    
    @objc dynamic var supermarketChainID: Int = 1
    
    @objc dynamic var enabled: Bool = true
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getStoreModel() -> StoreModel {
        return StoreModel(
            id: id,
            name: name,
            address: address,
            openingHours: openingHours.map{ $0.getOpeningHourModel() },
            location: location!.getLocationModel(),
            facilities: facilities.map{ String($0) },
            supermarketChainID: supermarketChainID
        )
    }
}

class OpeningHourObject: Object {
    @objc dynamic var storeID: Int = 1

    @objc dynamic var opensAt: String? = nil
    @objc dynamic var closesAt: String? = nil
    @objc dynamic var closedToday: Bool = true
    @objc dynamic var dayOfWeek:Int = 1
    
    func getOpeningHourModel() -> OpeningHourModel {
        return OpeningHourModel(
            storeID: storeID,
            opensAt: opensAt,
            closesAt: closesAt,
            closedToday: closedToday,
            dayOfWeek: dayOfWeek
        )
    }
}

class LocationObject: Object {
    var storeID: Int = 1
    
    var regionID: Int = 1
    
    @objc dynamic var city: String = ""
    @objc dynamic var addressLine1: String = ""
    
    @objc dynamic var addressLine2: String? = nil
    @objc dynamic var addressLine3: String? = nil
    
    @objc dynamic var postcode: String = ""

    var latitude =  RealmOptional<Double>()
    var longitude =  RealmOptional<Double>()
    
    func getLocationModel() -> LocationModel {
        return LocationModel(
            storeID: storeID,
            
            regionID: regionID,
            
            city: city,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            addressLine3: addressLine3,
            postcode: postcode,
            latitude: latitude.value,
            longitude: longitude.value
        )
    }
}
