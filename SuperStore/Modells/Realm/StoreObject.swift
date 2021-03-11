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
    @objc dynamic var logo: String = ""
    
    var facilities = List<String>()
    
    var openingHours = List<OpeningHourObject>()
    @objc dynamic var location: LocationObject?
    
    @objc dynamic var storeTypeID: Int = 1
    
    func getStoreModel() -> StoreModel {
        return StoreModel(
            id: id,
            name: name,
            logo: logo,
            address: address,
            openingHours: openingHours.map{ $0.getOpeningHourModel() },
            location: location!.getLocationModel(),
            facilities: facilities.map{ String($0) },
            storeTypeID: storeTypeID
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
    
    @objc dynamic var city: String = ""
    @objc dynamic var addressLine1: String = ""
    
    @objc dynamic var addressLine2: String? = nil
    @objc dynamic var addressLine3: String? = nil
    
    @objc dynamic var postcode: String = ""

    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    func getLocationModel() -> LocationModel {
        return LocationModel(
            storeID: storeID,
            city: city,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            addressLine3: addressLine3,
            postcode: postcode,
            latitude: latitude,
            longitude: longitude
        )
    }
}
