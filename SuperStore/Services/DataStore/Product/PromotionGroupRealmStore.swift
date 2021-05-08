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
    
    private func getPromotionGroupObject(storeTypeID: Int, title: String) -> PromotionGroupObject? {
        return realm?.objects(PromotionGroupObject.self).filter("storeTypeID = %@ AND title = %@", storeTypeID, title).first
    }
    
    private func getStorePromotionGroups(storeTypeID: Int) -> Results<PromotionGroupObject>? {
        return realm?.objects(PromotionGroupObject.self).filter("storeTypeID = %@", storeTypeID)
    }
    
    private func getNotFoundPromotionGroups(storeTypeID: Int, titles: [String]) -> Results<PromotionGroupObject>? {
        return realm?.objects(PromotionGroupObject.self).filter("storeTypeID = %@ AND NOT title in %@", storeTypeID, titles)
    }
    
    func createPromotionGroups(storeTypeID: Int, promotionsGroups: [PromotionGroupModel]){
        // Array Of Promotion Names. Contains Promotions. Contains Products.
        deletePromotionGroupsByStoreType(storeTypeID: storeTypeID, promotionsGroups: promotionsGroups)
        
        for promotionGroup in promotionsGroups {
            if getPromotionGroupObject(storeTypeID: promotionGroup.storeTypeID, title: promotionGroup.title) == nil {
                try? realm?.write({
                    let savedPromotionGroupObject = createPromotionGroupObject(promotionGroup: promotionGroup)
                    realm?.add(savedPromotionGroupObject)
                })
            }
        }
    }
    
    
    func setPromotionGroupPromotions(storeTypeID: Int, title: String, promotions: [PromotionModel]){
        if let savedPromotionGroup = getPromotionGroupObject(storeTypeID: storeTypeID, title: title){
            try? realm?.write({
                savedPromotionGroup.promotions.removeAll()
                
                promotions.forEach{ $0.products.forEach{ $0.promotion = nil}}
                
                for savedPromotion in promotions.map({ promotionStore.createPromotionObject(promotion: $0)}) {
                    savedPromotionGroup.promotions.append(savedPromotion)
                }
            })
        }
    }
    
}

extension PromotionGroupRealmStore {
    func getPromotionGroups(storeTypeID: Int) -> [PromotionGroupModel]{
        if let savedPromotionGroups = getStorePromotionGroups(storeTypeID: storeTypeID) {
            return savedPromotionGroups.map{ $0.getPromotionGroupModel() }
        }
        
        return []
    }
    
    func getPromotionGroup(storeTypeID: Int, title: String) -> PromotionGroupModel? {
        return getPromotionGroupObject(storeTypeID: storeTypeID, title: title)?.getPromotionGroupModel()
    }
}

extension PromotionGroupRealmStore {
    func createPromotionGroupObject(promotionGroup: PromotionGroupModel) -> PromotionGroupObject {
        
        if let savedPromotionGroup = getPromotionGroupObject(storeTypeID: promotionGroup.storeTypeID, title: promotionGroup.title){
            return savedPromotionGroup
        }

        let savedPromotionGroup = PromotionGroupObject()
        
        savedPromotionGroup.title = promotionGroup.title
        savedPromotionGroup.storeTypeID = promotionGroup.storeTypeID
        
        return savedPromotionGroup
    }
    
    private func deletePromotionGroupsByStoreType(storeTypeID: Int, promotionsGroups: [PromotionGroupModel]){
        // Delete all promotion groups by store
        let titles: [String] = promotionsGroups.map{ $0.title }
        
        if let unfoundPromotionGroups = getNotFoundPromotionGroups(storeTypeID: storeTypeID, titles: titles){
            try? realm?.write({
                realm?.delete(unfoundPromotionGroups)
            })
        }
    }
}
