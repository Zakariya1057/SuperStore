//
//  StoreAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class StoreAPI: StoreRequestProtocol {

    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
    
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
}
