//
//  ShowPromotionInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowPromotionBusinessLogic
{
    func getPromotion(request: ShowPromotion.GetPromotion.Request)
    
    var selectedListID: Int? { get set }
}

protocol ShowPromotionDataStore
{
    var promotionID: Int { get set }
    var selectedListID: Int? { get set }
}

class ShowPromotionInteractor: ShowPromotionBusinessLogic, ShowPromotionDataStore
{
    
    var presenter: ShowPromotionPresentationLogic?
    var promotionWorker: PromotionWorker = PromotionWorker(promotionAPI: PromotionAPI())
    
    var promotionID: Int = 1
    var selectedListID: Int? = nil
    
    var userSession = UserSessionWorker()
    
    func getPromotion(request: ShowPromotion.GetPromotion.Request)
    {
        promotionWorker.getPromotion(promotionID: promotionID) { (promotion: PromotionModel?, error: String?) in
            var response = ShowPromotion.GetPromotion.Response(promotion: promotion, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentPromotion(response: response)
        }

    }
}
