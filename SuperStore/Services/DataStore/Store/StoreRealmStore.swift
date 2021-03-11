//
//  StoreRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 11/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class StoreRealmStore: DataStore, StoreDataProtocol {
    
    private func getStoreObject(storeID: Int) -> StoreObject? {
        return realm?.objects(StoreObject.self).filter("id = %@", storeID).first
    }
    
    private func getStoreObjects(storeTypeID: Int) -> Results<StoreObject>? {
        return realm?.objects(StoreObject.self).filter("storeTypeID = %@", storeTypeID)
    }
    
    
    func getStore(storeID: Int) -> StoreModel? {
        return getStoreObject(storeID: storeID)?.getStoreModel()
    }
    
    func getStores(storeTypeID: Int) -> [StoreModel] {
        return getStoreObjects(storeTypeID: storeTypeID)?.map { $0.getStoreModel() } ?? []
    }
    
    func createStores(stores: [StoreModel]) {
        for store in stores {
            createStore(store: store)
        }
    }
    
    func createStore(store: StoreModel) {
        
        if let savedStore = getStoreObject(storeID: store.id) {
            updateStore(store: store, savedStore: savedStore)
        } else {
            try? realm?.write({
                let savedStore: StoreObject = createStoreObject(store: store)
                realm?.add(savedStore)
            })
        }
    }
    
    func updateStore(store: StoreModel, savedStore: StoreObject){
        try? realm?.write({
            savedStore.id = store.id
            savedStore.name = store.name
            savedStore.address = store.address
            savedStore.logo = store.logo
            
            if let savedLocation = savedStore.location {
                realm?.delete(savedLocation)
            }
            savedStore.location = createLocationObject(location: store.location)
            
            if store.openingHours.count > savedStore.openingHours.count {
                realm?.delete(savedStore.openingHours)
                
                for openingHourObject in createOpeningHoursObject(openingHours: store.openingHours){
                    savedStore.openingHours.append(openingHourObject)
                }
            }
            
            if store.facilities.count != 0 {
                savedStore.facilities.removeAll()
                
                for facility in store.facilities {
                    savedStore.facilities.append(facility)
                }
            }

            savedStore.storeTypeID = store.storeTypeID
        })
    }
}

extension StoreRealmStore {
    
    func createStoreObject(store: StoreModel) -> StoreObject {
        let savedStore = StoreObject()
        
        savedStore.id = store.id
        savedStore.name = store.name
        savedStore.address = store.address
        savedStore.logo = store.logo
        
        savedStore.location = createLocationObject(location: store.location)
        savedStore.openingHours = createOpeningHoursObject(openingHours: store.openingHours)
        savedStore.facilities = createFacilitiesObject(facilities: store.facilities)
        
        savedStore.storeTypeID = store.storeTypeID
        
        return savedStore
    }
    
    func createLocationObject(location: LocationModel) -> LocationObject {
        let savedLocation = LocationObject()
        
        savedLocation.addressLine1 = location.addressLine1
        savedLocation.addressLine2 = location.addressLine2
        savedLocation.addressLine3 = location.addressLine3
        
        savedLocation.city = location.city
        savedLocation.postcode = location.postcode
        
        savedLocation.latitude = location.latitude
        savedLocation.longitude = location.longitude
        
        savedLocation.storeID = location.storeID
        
        return savedLocation
    }
    
    func createOpeningHoursObject(openingHours: [OpeningHourModel]) -> List<OpeningHourObject> {
        let savedOpeningHours = List<OpeningHourObject>()
        
        for openingHour in openingHours {
            let savedOpeningHour = OpeningHourObject()
            
            savedOpeningHour.opensAt = openingHour.opensAt
            savedOpeningHour.closesAt = openingHour.closesAt
            savedOpeningHour.closedToday = openingHour.closedToday
            savedOpeningHour.dayOfWeek = openingHour.dayOfWeek
            savedOpeningHour.storeID = openingHour.storeID
            
            savedOpeningHours.append(savedOpeningHour)
        }
        
        return savedOpeningHours
    }
    
    func createFacilitiesObject(facilities: [String]) -> List<String> {
        let savedFacilities = List<String>()
        
        for facility in facilities {
            savedFacilities.append(facility)
        }
        
        return savedFacilities
    }
    
}

extension StoreRealmStore {
    
}
