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
    var storeAPI: StoreRequestProtocol
    
    init(storeAPI: StoreRequestProtocol) {
        self.storeAPI = storeAPI
    }
    
    func getStores(storeTypeID: Int, completionHandler: @escaping (_ stores: [StoreModel], _ error: String?) -> Void){
        storeAPI.getStores(storeTypeID: storeTypeID, completionHandler: completionHandler)
    }
    
    func getStore(storeID: Int, completionHandler: @escaping (_ store: StoreModel?, _ error: String?) -> Void){
        storeAPI.getStore(storeID: storeID, completionHandler: completionHandler)
    }
}

protocol StoreRequestProtocol {
    func getStore(storeID: Int, completionHandler: @escaping (_ product: StoreModel?, _ error: String?) -> Void)
    func getStores(storeTypeID: Int, completionHandler: @escaping (_ stores: [StoreModel], _ error: String?) -> Void)
}
