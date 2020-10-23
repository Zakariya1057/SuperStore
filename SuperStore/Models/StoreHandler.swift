//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol StoreDelegate {
    func contentLoaded(store: StoreModel)
    func errorHandler(_ message:String)
    func logOutUser()
}

struct StoreHandler {
    
    var delegate: StoreDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(store_id: Int){
        let hostURL = K.Host
        let storePath = K.Request.Store
        let urlString = "\(hostURL)/\(storePath)/\(store_id)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let decodedStoreData = try decoder.decode(StoreData.self, from: data)
            let storeHours = decodedStoreData.opening_hours!
            let storeLocation = decodedStoreData.location
            let storeFacilities = decodedStoreData.facilities!
            
            var opening_hours: [OpeningHoursModel] = []
            var facilities: [String] = []
            
            let location:LocationModel = LocationModel(store_id: decodedStoreData.id, city: storeLocation.city, address_line1: storeLocation.address_line1, address_line2: storeLocation.address_line2, address_line3: storeLocation.address_line3, postcode: storeLocation.postcode, latitude: storeLocation.latitude, longitude:storeLocation.longitude )
            
            for hour in storeHours {
                opening_hours.append(OpeningHoursModel(store_id: decodedStoreData.id, opens_at: hour.opens_at, closes_at: hour.closes_at, closed_today: hour.closed_today ?? false, day_of_week: hour.day_of_week))
            }
            
            for facility in storeFacilities {
                facilities.append(facility.name.lowercased())
            }
            
            let store = StoreModel(id: decodedStoreData.id, name: decodedStoreData.name, logo: decodedStoreData.small_logo, opening_hours: opening_hours, location: location, facilities: facilities, store_type_id: decodedStoreData.store_type_id)

            DispatchQueue.main.async {
                self.delegate?.contentLoaded(store: store)
            }
        

            
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
