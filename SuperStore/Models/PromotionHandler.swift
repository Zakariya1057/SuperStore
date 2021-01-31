//
//  PromotionController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol PromotionDelegate {
    func contentLoaded(promotion: PromotionModel)
    func errorHandler(_ message:String)
    func logOutUser()
}


struct PromotionHandler {
        
    var delegate: PromotionDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(promotionID: Int){
        let urlString = "\(K.Host)/\(K.Request.Grocery.Promotion)/\(promotionID)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(PromotionDataResponse.self, from: data)
            let promotionData = data.data
            
            var promotion: PromotionModel = PromotionModel(id: promotionData.id, name: promotionData.name, quantity: promotionData.quantity ?? 0, price: promotionData.price, forQuantity: promotionData.for_quantity)
            
            for product in promotionData.products ?? [] {

                promotion.products.append(
                    ProductModel(id: product.id, name: product.name, smallImage: product.small_image, largeImage: product.large_image, description: product.description, quantity: 0, price: product.price, avgRating: product.avg_rating, totalReviewsCount: product.total_reviews_count, promotion: promotion, storage: product.storage, weight: product.weight, parentCategoryId: product.parent_category_id, parentCategoryName: product.parent_category_name, childCategoryName: nil, dietaryInfo: product.dietary_info, allergenInfo: product.allergen_info, brand: product.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: [])
                )
                

            }

            DispatchQueue.main.async {
                self.delegate?.contentLoaded(promotion: promotion)
            }

        } catch {
            processError("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        print(message)
        self.delegate?.errorHandler(message)
    }
}
