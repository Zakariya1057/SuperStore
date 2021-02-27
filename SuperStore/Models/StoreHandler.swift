////
////  DataHandler.swift
////  ZPlayer
////
////  Created by Zakariya Mohummed on 25/05/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import Foundation
//
//protocol StoreDelegate {
//    func contentLoaded(store: StoreModel)
//    func errorHandler(_ message:String)
//    func logOutUser()
//}
//
//struct StoreHandler {
//    
//    var delegate: StoreDelegate?
//    
//    let requestHandler = RequestHandler()
//    
//    func request(store_id: Int){
//        let hostURL = K.Host
//        let storePath = K.Request.Store
//        let urlString = "\(hostURL)/\(storePath)/\(store_id)"
//        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
//    }
//    
//    func processResults(_ data:Data){
//        
//        do {
//            
//            let decoder = JSONDecoder()
//            let decodedStoreResponse = try decoder.decode(StoreResponseData.self, from: data)
//            let decodedStoreData = decodedStoreResponse.data
//            let storeHours = decodedStoreData.opening_hours!
//            let storeLocation = decodedStoreData.location
//            let storeFacilities = decodedStoreData.facilities!
//            
//            var opening_hours: [OpeningHoursModel] = []
//            var facilities: [String] = []
//            
//            let location:LocationModel = LocationModel(storeID: decodedStoreData.id, city: storeLocation.city, addressLine1: storeLocation.address_line1, addressLine2: storeLocation.address_line2, addressLine3: storeLocation.address_line3, postcode: storeLocation.postcode, latitude: storeLocation.latitude, longitude:storeLocation.longitude )
//            
//            for hour in storeHours {
//                opening_hours.append(OpeningHoursModel(storeID: decodedStoreData.id, opensAt: hour.opens_at, closesAt: hour.closes_at, closedToday: hour.closed_today ?? false, dayOfWeek: hour.day_of_week))
//            }
//            
//            for facility in storeFacilities {
//                facilities.append(facility.name.lowercased())
//            }
//            
//            let store = StoreModel(id: decodedStoreData.id, name: decodedStoreData.name, logo: decodedStoreData.small_logo, openingHours: opening_hours, location: location, facilities: facilities, storeTypeID: decodedStoreData.store_type_id)
//
//            DispatchQueue.main.async {
//                self.delegate?.contentLoaded(store: store)
//            }
//        
//
//            
//        } catch {
//            processError("Decoding Data Error: \(error)")
//        }
//        
//        
//    }
//    
//    func logOutUser(){
//        self.delegate?.logOutUser()
//    }
//    
//    func processError(_ message:String){
//        print(message)
//        self.delegate?.errorHandler(message)
//    }
//}
