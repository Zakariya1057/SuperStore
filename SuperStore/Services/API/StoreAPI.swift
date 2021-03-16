//
//  StoreAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class StoreAPI: StoreRequestProtocol {

    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
    
    func getStores(storeTypeID: Int, latitude: Double?, longitude: Double?, completionHandler: @escaping (_ stores: [StoreModel], _ error: String?) -> Void){
        
        let storeData: Parameters = [
            "store_type_id": storeTypeID,
            "latitude": latitude ?? 0,
            "longitude": longitude ?? 0
        ]
        
        requestWorker.post(url: Config.Route.Search.Results.Store, data: storeData) { (response: () throws -> Data) in
            do {
                let data = try response()
                let storesDataResponse =  try self.jsonDecoder.decode(StoresDataResponse.self, from: data)
                let stores = self.createStoreModels(storesDataResponse: storesDataResponse)
                completionHandler(stores, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get store. Decoding error, please try again later.")
            }
        }
    }
    
    func getStore(storeID: Int, completionHandler: @escaping (StoreModel?, String?) -> Void) {
        let url: String = Config.Route.Store + "/" + String(storeID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let storeDataResponse =  try self.jsonDecoder.decode(StoreDataResponse.self, from: data)
                let store = self.createStoreModel(storeDataResponse: storeDataResponse)
                completionHandler(store, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to get store. Decoding error, please try again later.")
            }
        }
    }
}

extension StoreAPI {
    private func createStoreModel(storeDataResponse: StoreDataResponse) -> StoreModel {
        let storeData = storeDataResponse.data
        return storeData.getStoreModel()
    }
    
    private func createStoreModels(storesDataResponse: StoresDataResponse) -> [StoreModel] {
        let storesData: [StoreData] = storesDataResponse.data
        return storesData.map { (store: StoreData) in
            return store.getStoreModel()
        }
    }
}
