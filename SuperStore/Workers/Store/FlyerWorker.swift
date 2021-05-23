//
//  FlyerWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FlyerWorker
{
    private var flyerAPI: FlyerRequestProtocol
    private var flyerStore: FlyerStoreProtocol
    
    init(flyerAPI: FlyerRequestProtocol) {
        self.flyerAPI = flyerAPI
        self.flyerStore = FlyerRealmStore()
    }
    
    func getFlyers(storeID: Int, completionHandler: @escaping (_ flyers: [FlyerModel], _ error: String?) -> Void){
        let flyers = flyerStore.getFlyers(storeID: storeID)
        if flyers.count > 0 {
            completionHandler(flyers, nil)
        }

        flyerAPI.getFlyers(storeID: storeID) { (flyers: [FlyerModel], error: String?) in
            if flyers.count > 0 {
                self.flyerStore.createFlyers(flyers: flyers)
            }
            
            completionHandler(flyers, error)
        }
    }
    
    func getFlyer(flyerName: Int, completionHandler: @escaping (_ flyer: FlyerModel?, _ error: String?) -> Void){
        
    }
}

protocol FlyerRequestProtocol {
    func getFlyers(storeID: Int, completionHandler: @escaping (_ flyers: [FlyerModel], _ error: String?) -> Void)
}

protocol FlyerStoreProtocol {
    func createFlyer(flyer: FlyerModel)
    func createFlyers(flyers: [FlyerModel])
    func getFlyers(storeID: Int) -> [FlyerModel]
}
