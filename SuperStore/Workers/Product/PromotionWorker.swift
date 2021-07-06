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
    
    func getAllPromotions(regionID: Int, supermarketChainID: Int, completionHandler: @escaping (_ promotionGroups: [PromotionGroupModel], _ error: String?) -> Void){
        let promotionsGroups = promotionGroupStore.getPromotionGroups(regionID: regionID, supermarketChainID: supermarketChainID)
        if promotionsGroups.count > 0 {
            completionHandler(promotionsGroups, nil)
        }
        
        promotionAPI.getAllPromotions(regionID: regionID, supermarketChainID: supermarketChainID) { (promotionGroups: [PromotionGroupModel], error: String?) in
            if error == nil {
                self.promotionGroupStore.createPromotionGroups(regionID: regionID, supermarketChainID: supermarketChainID, promotionsGroups: promotionGroups)
            }
            
            completionHandler(promotionGroups, error)
        }
    }
    
    func getPromotionGroup(regionID: Int, supermarketChainID: Int, title: String, completionHandler: @escaping (_ promotions: [PromotionModel], _ error: String?) -> Void){
        let promotionGroup = promotionGroupStore.getPromotionGroup(regionID: regionID, supermarketChainID: supermarketChainID, title: title)
        if let promotionGroup = promotionGroup, promotionGroup.promotions.count > 0 {
            completionHandler(promotionGroup.promotions, nil)
        }
        
        promotionAPI.getPromotionGroup(regionID: regionID, supermarketChainID: supermarketChainID, title: title) { (promotions: [PromotionModel], error: String?) in
            if error == nil {
                self.promotionGroupStore.setPromotionGroupPromotions(regionID: regionID, supermarketChainID: supermarketChainID, title: title, promotions: promotions)
            }
            
            completionHandler(promotions, error)
        }
    }
    
    func getPromotion(regionID: Int, promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void){
        
        let promotion = self.promotionStore.getPromotion(promotionID: promotionID)
        if let promotion = promotion {
            if promotion.products.count > 0 || !userSession.isOnline() {
                completionHandler(promotion, nil)
            }
        }
        
        promotionAPI.getPromotion(regionID: regionID, promotionID: promotionID) { (promotion: PromotionModel?, error: String?) in
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

}

protocol PromotionRequestProtocol {
    func getPromotion(regionID: Int, promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void)
    func getAllPromotions(regionID: Int, supermarketChainID: Int, completionHandler: @escaping (_ promotionGroups: [PromotionGroupModel], _ error: String?) -> Void)
    func getPromotionGroup(regionID: Int, supermarketChainID: Int, title: String, completionHandler: @escaping (_ promotionGroups: [PromotionModel], _ error: String?) -> Void)
}

protocol PromotionStoreProtocol {
    func createPromotion(promotion: PromotionModel)
    func getPromotion(promotionID: Int) -> PromotionModel?
    
    func promotionExpired(promotion: PromotionModel) -> Bool
    
    func deletePromotion(promotionID: Int)
    
    func createPromotionObject(promotion: PromotionModel) -> PromotionObject
    
}

protocol PromotionGroupStoreProtocol {
    func createPromotionGroups(regionID: Int, supermarketChainID: Int, promotionsGroups: [PromotionGroupModel])
    func setPromotionGroupPromotions(regionID: Int, supermarketChainID: Int, title: String, promotions: [PromotionModel])
    
    func getPromotionGroups(regionID: Int, supermarketChainID: Int) -> [PromotionGroupModel]
    func getPromotionGroup(regionID: Int, supermarketChainID: Int, title: String) -> PromotionGroupModel?
}
