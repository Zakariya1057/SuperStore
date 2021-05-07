//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class PromotionAPI: API, PromotionRequestProtocol {
    
    func getPromotion(promotionID: Int, completionHandler: @escaping (PromotionModel?, String?) -> Void) {
        let url = Config.Route.Promotion.Show + "/" + String(promotionID)
        
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
    
    func getAllPromotions(storeTypeID: Int, completionHandler: @escaping (_ promotions: [PromotionModel], _ error: String?) -> Void){
        let url = Config.Route.Promotion.All + "/" + String(storeTypeID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let promotionsDataResponse =  try self.jsonDecoder.decode(AllPromotionsDataResponse.self, from: data)
                let promotion = self.createPromotionsModel(promotionsDataResponse: promotionsDataResponse)
                completionHandler(promotion, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get offers. Decoding error, please try again later.")
            }
        }
    }
    
}

extension PromotionAPI {
    
    private func createPromotionsModel(promotionsDataResponse: AllPromotionsDataResponse?) -> [PromotionModel] {
        if let promotionsDataResponse = promotionsDataResponse {
            let promotions = promotionsDataResponse.data
            return promotions.map{ $0.getPromotionModel() }
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

