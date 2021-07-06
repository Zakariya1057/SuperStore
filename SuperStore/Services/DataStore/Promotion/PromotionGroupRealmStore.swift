//
//  PromotionRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class PromotionGroupRealmStore: DataStore, PromotionGroupStoreProtocol {
    
    private lazy var promotionStore: PromotionRealmStore = PromotionRealmStore()
    
    private func getPromotionGroupObject(regionID: Int, supermarketChainID: Int, title: String) -> PromotionGroupObject? {
        return realm?.objects(PromotionGroupObject.self).filter("regionID = %@ AND supermarketChainID = %@ AND title = %@", regionID, supermarketChainID, title).first
    }
    
    private func getStorePromotionGroups(regionID: Int, supermarketChainID: Int) -> Results<PromotionGroupObject>? {
        return realm?.objects(PromotionGroupObject.self).filter("regionID = %@ AND supermarketChainID = %@", regionID, supermarketChainID)
    }
    
    private func getNotFoundPromotionGroups(regionID: Int, supermarketChainID: Int, titles: [String]) -> Results<PromotionGroupObject>? {
        return realm?.objects(PromotionGroupObject.self).filter("regionID = %@ AND supermarketChainID = %@ AND NOT title in %@", regionID, supermarketChainID, titles)
    }
    
    func createPromotionGroups(regionID: Int, supermarketChainID: Int, promotionsGroups: [PromotionGroupModel]){
        // Array Of Promotion Names. Contains Promotions. Contains Products.
        deletePromotionGroupsByStoreType(regionID: regionID, supermarketChainID: supermarketChainID, promotionsGroups: promotionsGroups)
        
        for promotionGroup in promotionsGroups {
            if getPromotionGroupObject(regionID: regionID, supermarketChainID: promotionGroup.supermarketChainID, title: promotionGroup.title) == nil {
                try? realm?.write({
                    let savedPromotionGroupObject = createPromotionGroupObject(promotionGroup: promotionGroup)
                    realm?.add(savedPromotionGroupObject)
                })
            }
        }
    }
    
    
    func setPromotionGroupPromotions(regionID: Int, supermarketChainID: Int, title: String, promotions: [PromotionModel]){
        if let savedPromotionGroup = getPromotionGroupObject(regionID: regionID, supermarketChainID: supermarketChainID, title: title){
            try? realm?.write({
                savedPromotionGroup.promotions.removeAll()
                
                promotions.forEach{ $0.products.forEach{ $0.price!.promotion = nil}}
                
                for savedPromotion in promotions.map({ promotionStore.createPromotionObject(promotion: $0)}) {
                    savedPromotionGroup.promotions.append(savedPromotion)
                }
            })
        }
    }
    
}

extension PromotionGroupRealmStore {
    func getPromotionGroups(regionID: Int, supermarketChainID: Int) -> [PromotionGroupModel]{
        if let savedPromotionGroups = getStorePromotionGroups(regionID: regionID, supermarketChainID: supermarketChainID) {
            return savedPromotionGroups.map{ $0.getPromotionGroupModel() }
        }
        
        return []
    }
    
    func getPromotionGroup(regionID: Int, supermarketChainID: Int, title: String) -> PromotionGroupModel? {
        return getPromotionGroupObject(regionID: regionID, supermarketChainID: supermarketChainID, title: title)?.getPromotionGroupModel()
    }
}

extension PromotionGroupRealmStore {
    func createPromotionGroupObject(promotionGroup: PromotionGroupModel) -> PromotionGroupObject {
        
        if let savedPromotionGroup = getPromotionGroupObject(regionID: promotionGroup.regionID, supermarketChainID: promotionGroup.supermarketChainID, title: promotionGroup.title){
            return savedPromotionGroup
        }

        let savedPromotionGroup = PromotionGroupObject()
        
        savedPromotionGroup.title = promotionGroup.title
        
        savedPromotionGroup.regionID = promotionGroup.regionID
        savedPromotionGroup.supermarketChainID = promotionGroup.supermarketChainID
        
        return savedPromotionGroup
    }
    
    private func deletePromotionGroupsByStoreType(regionID: Int, supermarketChainID: Int, promotionsGroups: [PromotionGroupModel]){
        // Delete all promotion groups by store
        let titles: [String] = promotionsGroups.map{ $0.title }
        
        if let unfoundPromotionGroups = getNotFoundPromotionGroups(regionID: regionID, supermarketChainID: supermarketChainID, titles: titles){
            try? realm?.write({
                realm?.delete(unfoundPromotionGroups)
            })
        }
    }
}
