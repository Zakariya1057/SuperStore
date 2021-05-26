//
//  StoreWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class StoreWorker
{
    private var storeAPI: StoreRequestProtocol
    private var storeStore: StoreStoreProtocol
    
    init(storeAPI: StoreRequestProtocol) {
        self.storeAPI = storeAPI
        self.storeStore = StoreRealmStore()
    }
    
    func getStores(storeTypeID: Int, latitude: Double?, longitude: Double?, completionHandler: @escaping (_ stores: [StoreModel], _ error: String?) -> Void){
        
        let stores = storeStore.getStores(storeTypeID: storeTypeID)
        if stores.count > 0 {
            completionHandler(stores, nil)
        }
        
        storeAPI.getStores(storeTypeID: storeTypeID, latitude: latitude, longitude: longitude) { (stores: [StoreModel], error: String?) in
            if stores.count > 0 {
                self.storeStore.createStores(stores: stores)
            }
            
            completionHandler(stores, error)
        }
    }
    
    func getStore(storeID: Int, completionHandler: @escaping (_ store: StoreModel?, _ error: String?) -> Void){
        
        if let store = storeStore.getStore(storeID: storeID){
            completionHandler(store, nil)
        }
        
        storeAPI.getStore(storeID: storeID) { (store: StoreModel?, error: String?) in
            if let store = store {
                self.storeStore.createStore(store: store)
            }
            
            completionHandler(store, error)
        }
    }
}

protocol StoreRequestProtocol {
    func getStore(storeID: Int, completionHandler: @escaping (_ product: StoreModel?, _ error: String?) -> Void)
    func getStores(storeTypeID: Int, latitude: Double?, longitude: Double?, completionHandler: @escaping (_ stores: [StoreModel], _ error: String?) -> Void)
}

protocol StoreStoreProtocol {
    func createStore(store: StoreModel)
    func createStores(stores: [StoreModel])
    func getStore(storeID: Int) -> StoreModel?
    func getStores(storeTypeID: Int) -> [StoreModel]
    
    func createStoreObject(store: StoreModel) -> StoreObject
}
