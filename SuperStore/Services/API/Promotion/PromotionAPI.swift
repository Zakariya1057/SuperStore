//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class PromotionAPI: API, PromotionRequestProtocol {
    
    func getAllPromotions(regionID: Int, storeTypeID: Int, completionHandler: @escaping (_ promotionGroups: [PromotionGroupModel], _ error: String?) -> Void){
        let url = Config.Route.Promotion.All + "/" + String(storeTypeID) + "?region_id=\(regionID)"
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let promotionsDataResponse =  try self.jsonDecoder.decode(AllPromotionsDataResponse.self, from: data)
                let promotionGroups = self.createPromotionGroups(promotionsDataResponse: promotionsDataResponse, regionID: regionID, storeTypeID: storeTypeID)
                completionHandler(promotionGroups, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get offers. Decoding error, please try again later.")
            }
        }
    }
    
    func getPromotionGroup(regionID: Int, storeTypeID: Int, title: String, completionHandler: @escaping (_ promotionGroups: [PromotionModel], _ error: String?) -> Void){
        let url = Config.Route.Promotion.All + "/" + String(storeTypeID) + "/" + title + "?region_id=\(regionID)"
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let promotionsDataResponse =  try self.jsonDecoder.decode(PromotionGroupDataResponse.self, from: data)
                let promotionGroups = self.createPromotionsModel(promotionsDataResponse: promotionsDataResponse)
                completionHandler(promotionGroups, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get offers. Decoding error, please try again later.")
            }
        }
    }
    
    func getPromotion(regionID: Int, promotionID: Int, completionHandler: @escaping (PromotionModel?, String?) -> Void) {
        let url = Config.Route.Promotion.Show + "/" + String(promotionID) + "?region_id=\(regionID)"
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let promotionDataResponse =  try self.jsonDecoder.decode(PromotionDataResponse.self, from: data)
                let promotion = self.createPromotionModel(promotionDataResponse: promotionDataResponse)
                completionHandler(promotion, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to get promotion. Decoding error, please try again later.")
            }
        }
    }

}

extension PromotionAPI {
    
    private func createPromotionsModel(promotionsDataResponse: PromotionGroupDataResponse?) -> [PromotionModel] {
        
        if let promotionsDataResponse = promotionsDataResponse {
            let promotionsGroup = promotionsDataResponse.data
            return promotionsGroup.map{ $0.getPromotionModel() }
        }
        
        return []
    }
    
    private func createPromotionGroups(promotionsDataResponse: AllPromotionsDataResponse?, regionID: Int, storeTypeID: Int) -> [PromotionGroupModel] {
        
        if let promotionsDataResponse = promotionsDataResponse {
            let promotionGroups = promotionsDataResponse.data
            return promotionGroups.map{ PromotionGroupModel(title: $0, regionID: regionID, storeTypeID: storeTypeID) }
        }
        
        return []
    }
    
    private func createPromotionModel(promotionDataResponse: PromotionDataResponse?) -> PromotionModel? {
        
        if let promotionDataResponse = promotionDataResponse {
            let promotionData = promotionDataResponse.data
            return promotionData.getPromotionModel()
        }
        
        return nil
    }
}
