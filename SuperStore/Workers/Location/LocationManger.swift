//
//  LocationManger.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 15/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit
import MapKit

class LocationWorker
{
    var locationAPI: LocationRequestProtocol
    var locationStore: LocationStoreProtocol
    
    init(locationAPI: LocationRequestProtocol) {
        self.locationAPI = locationAPI
        self.locationStore = LocationRealmStore()
    }
    
    func updateLocation(loggedIn: Bool, latitude: Double, longitude: Double, completionHandler: @escaping (_ error: String?) -> Void){
        locationStore.updateLocation(latitude: latitude, longitude: longitude)
        
        if(loggedIn){
            locationAPI.updateLocation(latitude: latitude, longitude: longitude, completionHandler: completionHandler)
        }
    }
}

protocol LocationRequestProtocol {
    func updateLocation(latitude: Double, longitude: Double, completionHandler: @escaping ( _ error: String?) -> Void)
}

protocol LocationStoreProtocol {
    func updateLocation(latitude: Double, longitude: Double)
}
