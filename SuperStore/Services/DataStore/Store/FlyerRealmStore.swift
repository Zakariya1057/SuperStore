//
//  FlyerRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class FlyerRealmStore: DataStore, FlyerStoreProtocol {
    private lazy var productStore: ProductStoreProtocol = ProductRealmStore()
    
    private func getFlyerObject(url: String) -> FlyerObject? {
        return realm?.objects(FlyerObject.self).filter("url = %@", url).first
    }
    
    private func getFlyerObject(id: Int) -> FlyerObject? {
        return realm?.objects(FlyerObject.self).filter("id = %@", id).first
    }
    
    private func getFlyerObjects(storeID: Int) -> Results<FlyerObject>? {
        return realm?.objects(FlyerObject.self).filter("storeID = %@", storeID)
    }
    
    func getFlyers(storeID: Int) -> [FlyerModel] {
        if let savedFlyers = getFlyerObjects(storeID: storeID){
            return savedFlyers.map{ $0.getFlyerModel() }
        }
        
        return []
    }
    
    func createFlyers(flyers: [FlyerModel]) {
        for flyer in flyers {
            createFlyer(flyer: flyer)
        }
    }
    
    func createFlyer(flyer: FlyerModel) {
        if let savedFlyer = getFlyerObject(url: flyer.url){
            updateFlyer(flyer: flyer, savedFlyer: savedFlyer)
        } else {
            try? realm?.write({
                let savedFlyer: FlyerObject = createFlyerObject(flyer: flyer)
                realm?.add(savedFlyer)
            })
        }
    }
}

extension FlyerRealmStore {
    func createFlyerProducts(flyerID: Int, products: [ProductModel]) {
        if let savedFlyer = getFlyerObject(id: flyerID){
            try? realm?.write({
                setFlyerProducts(products: products, savedFlyer: savedFlyer)
            })
        }
    }
    
    func getFlyerProducts(flyerID: Int) -> [ProductModel] {
        if let savedFlyer = getFlyerObject(id: flyerID){
            return savedFlyer.products.map{ $0.getProductModel() }.compactMap ({ $0 })
        }
        return []
    }
}

extension FlyerRealmStore {
    func createFlyerObject(flyer: FlyerModel) -> FlyerObject {
        
        if let savedFlyer = getFlyerObject(url: flyer.url){
            return savedFlyer
        }
        
        let savedFlyer = FlyerObject()

        savedFlyer.id = flyer.id
        savedFlyer.name = flyer.name
        savedFlyer.week = flyer.week
        savedFlyer.url = flyer.url
        savedFlyer.storeID = flyer.storeID
        savedFlyer.supermarketChainID = flyer.supermarketChainID
        savedFlyer.validFrom = flyer.validFrom
        savedFlyer.validTo = flyer.validTo
        
        return savedFlyer
    }
    
    func setFlyerProducts(products: [ProductModel], savedFlyer: FlyerObject){
        savedFlyer.products.removeAll()
        
        for product in products {
            let savedProduct = productStore.createProductObject(product: product)
            savedFlyer.products.append(savedProduct)
        }
    }
    
    func updateFlyer(flyer: FlyerModel, savedFlyer: FlyerObject){
        try? realm?.write({
            savedFlyer.id = flyer.id
            savedFlyer.name = flyer.name
            savedFlyer.week = flyer.week
            savedFlyer.url = flyer.url
            savedFlyer.storeID = flyer.storeID
            savedFlyer.supermarketChainID = flyer.supermarketChainID
            savedFlyer.validFrom = flyer.validFrom
            savedFlyer.validTo = flyer.validTo
        })
    }
}
