//
//  PromotionWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class PromotionWorker {
    var promotionAPI: PromotionRequestProtocol
    
    init(promotionAPI: PromotionRequestProtocol) {
        self.promotionAPI = promotionAPI
    }
    
    func getPromotion(promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void){
        promotionAPI.getPromotion(promotionID: promotionID, completionHandler: completionHandler)
    }
}

protocol PromotionRequestProtocol {
    func getPromotion(promotionID: Int, completionHandler: @escaping (_ promotion: PromotionModel?, _ error: String?) -> Void)
}
