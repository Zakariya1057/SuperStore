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
    private var userSession: UserSessionWorker = UserSessionWorker()
    
    init(promotionAPI: PromotionRequestProtocol) {
        self.promotionAPI = promotionAPI
        self.promotionStore = PromotionRealmStore()
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
    
    func getAllPromotions(storeTypeID: Int, completionHandler: @escaping (_ promotionGroups: [String], _ error: String?) -> Void){
        promotionAPI.getAllPromotions(storeTypeID: storeTypeID) { (promotionGroups: [String], error: String?) in
            completionHandler(promotionGroups, error)
        }
    }
    
    func getPromotionGroup(storeTypeID: Int, title: String, completionHandler: @escaping (_ promotions: [PromotionModel], _ error: String?) -> Void){
        promotionAPI.getPromotionGroup(storeTypeID: storeTypeID, title: title) { (promotions: [PromotionModel], error: String?) in
            completionHandler(promotions, error)
        }
    }
}

protocol PromotionRequestProtocol {
    func getPromotion(promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void)
    func getAllPromotions(storeTypeID: Int, completionHandler: @escaping (_ promotionGroups: [String], _ error: String?) -> Void)
    func getPromotionGroup(storeTypeID: Int, title: String, completionHandler: @escaping (_ promotionGroups: [PromotionModel], _ error: String?) -> Void)
}

protocol PromotionStoreProtocol {
    func createPromotion(promotion: PromotionModel)
    func getPromotion(promotionID: Int) -> PromotionModel?
    
    func promotionExpired(promotion: PromotionModel) -> Bool
    
    func deletePromotion(promotionID: Int)
    
    func createPromotionObject(promotion: PromotionModel) -> PromotionObject
}
