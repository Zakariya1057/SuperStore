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
    
    func request(promotion_id: Int){
        let host_url = K.Host
        let promotion_path = K.Request.Grocery.Promotion
        let url_string = "\(host_url)/\(promotion_path)/\(promotion_id)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(PromotionDataResponse.self, from: data)
            let promotion_data = data.data
            
            var products:[ProductModel] = []
            
            var promotion: PromotionModel? = nil
            
            for product in promotion_data.products ?? [] {
                
                if promotion == nil {
                    promotion = PromotionModel(id: product.promotion!.id, name: product.promotion!.name, quantity: product.promotion!.quantity ?? 0, price: product.promotion!.price, forQuantity: product.promotion!.for_quantity)
                }
                
                products.append(
                    ProductModel(id: product.id, name: product.name, smallImage: product.small_image, largeImage: product.large_image, description: product.description, quantity: 0, price: product.price, avgRating: product.avg_rating, totalReviewsCount: product.total_reviews_count, promotion: promotion, storage: product.storage, weight: product.weight, parentCategoryId: product.parent_category_id, parentCategoryName: product.parent_category_name, childCategoryName: nil, dietary_info: product.dietary_info, allergen_info: product.allergen_info, brand: product.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: [])
                )
                

            }

            promotion!.products = products

            DispatchQueue.main.async {
                self.delegate?.contentLoaded(promotion: promotion!)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
