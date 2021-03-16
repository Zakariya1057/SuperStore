//
//  LocationRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 15/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class LocationRealmStore: DataStore, LocationStoreProtocol {
    func updateLocation(latitude: Double, longitude: Double) {
        try? realm?.write({
            let savedLocation = UserLocationObject()
            savedLocation.latitude = latitude
            savedLocation.longitude = longitude
            
            realm?.add(savedLocation)
        })
    }
}
