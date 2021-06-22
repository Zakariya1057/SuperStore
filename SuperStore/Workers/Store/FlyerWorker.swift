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
        let flyers: [FlyerModel] = flyerStore.getFlyers(storeID: storeID)

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
    
    func getFlyerProducts(flyerID: Int,  completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void){
        let products: [ProductModel] = flyerStore.getFlyerProducts(flyerID: flyerID)
        if products.count > 0 {
            completionHandler(products, nil)
        }

        flyerAPI.getFlyerProducts(flyerID: flyerID) { (products: [ProductModel], error: String?) in
            if error == nil {
                self.flyerStore.createFlyerProducts(flyerID: flyerID, products: products)
            }

            completionHandler(products, error)
        }
    }
}

protocol FlyerRequestProtocol {
    func getFlyers(storeID: Int, completionHandler: @escaping (_ flyers: [FlyerModel], _ error: String?) -> Void)
    func getFlyerProducts(flyerID: Int, completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void)
}

protocol FlyerStoreProtocol {
    func createFlyer(flyer: FlyerModel)
    func createFlyers(flyers: [FlyerModel])
    
    func createFlyerProducts(flyerID: Int, products: [ProductModel])
    
    func getFlyers(storeID: Int) -> [FlyerModel]
    func getFlyerProducts(flyerID: Int) -> [ProductModel]
}
