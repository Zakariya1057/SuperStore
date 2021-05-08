//
//  PromotionWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class PromotionWorker {
    private var promotionAPI: PromotionRequestProtocol
    private var promotionStore: PromotionStoreProtocol
    private var promotionGroupStore: PromotionGroupStoreProtocol
    
    private var userSession: UserSessionWorker = UserSessionWorker()
    
    init(promotionAPI: PromotionRequestProtocol) {
        self.promotionAPI = promotionAPI
        self.promotionStore = PromotionRealmStore()
        self.promotionGroupStore = PromotionGroupRealmStore()
    }
    
    func getPromotion(promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void){
        
        let promotion = self.promotionStore.getPromotion(promotionID: promotionID)
        if let promotion = promotion {
            if promotion.products.count > 0 || !userSession.isOnline() {
                completionHandler(promotion, nil)
            }
        }
        
        promotionAPI.getPromotion(promotionID: promotionID) { (promotion: PromotionModel?, error: String?) in
            let promotionModel = promotion
            
            if promotionModel != nil {
                if self.promotionStore.promotionExpired(promotion: promotionModel!){
                    promotionModel?.products = []
                }

                self.promotionStore.createPromotion(promotion: promotionModel!)
            }
            
            completionHandler(promotionModel, error)
        }
    }
    
    func getAllPromotions(storeTypeID: Int, completionHandler: @escaping (_ promotionGroups: [PromotionGroupModel], _ error: String?) -> Void){
        let promotionsGroups = promotionGroupStore.getPromotionGroups(storeTypeID: storeTypeID)
        if promotionsGroups.count > 0 {
            completionHandler(promotionsGroups, nil)
        }
        
        promotionAPI.getAllPromotions(storeTypeID: storeTypeID) { (promotionGroups: [PromotionGroupModel], error: String?) in
            if error == nil {
                self.promotionGroupStore.createPromotionGroups(storeTypeID: storeTypeID, promotionsGroups: promotionGroups)
            }
            
            completionHandler(promotionGroups, error)
        }
    }
    
    func getPromotionGroup(storeTypeID: Int, title: String, completionHandler: @escaping (_ promotions: [PromotionModel], _ error: String?) -> Void){
        let promotionGroup = promotionGroupStore.getPromotionGroup(storeTypeID: storeTypeID, title: title)
        if let promotionGroup = promotionGroup, promotionGroup.promotions.count > 0 {
            completionHandler(promotionGroup.promotions, nil)
        }
        
        promotionAPI.getPromotionGroup(storeTypeID: storeTypeID, title: title) { (promotions: [PromotionModel], error: String?) in
            if error == nil {
                self.promotionGroupStore.setPromotionGroupPromotions(storeTypeID: storeTypeID, title: title, promotions: promotions)
            }
            
            completionHandler(promotions, error)
        }
    }
}

protocol PromotionRequestProtocol {
    func getPromotion(promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void)
    func getAllPromotions(storeTypeID: Int, completionHandler: @escaping (_ promotionGroups: [PromotionGroupModel], _ error: String?) -> Void)
    func getPromotionGroup(storeTypeID: Int, title: String, completionHandler: @escaping (_ promotionGroups: [PromotionModel], _ error: String?) -> Void)
}

protocol PromotionStoreProtocol {
    func createPromotion(promotion: PromotionModel)
    func getPromotion(promotionID: Int) -> PromotionModel?
    
    func promotionExpired(promotion: PromotionModel) -> Bool
    
    func deletePromotion(promotionID: Int)
    
    func createPromotionObject(promotion: PromotionModel) -> PromotionObject
    
}

protocol PromotionGroupStoreProtocol {
    func createPromotionGroups(storeTypeID: Int, promotionsGroups: [PromotionGroupModel])
    func setPromotionGroupPromotions(storeTypeID: Int, title: String, promotions: [PromotionModel])
    
    func getPromotionGroups(storeTypeID: Int) -> [PromotionGroupModel]
    func getPromotionGroup(storeTypeID: Int, title: String) -> PromotionGroupModel?
}
