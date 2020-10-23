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
            
            for product_item in promotion_data.products ?? [] {
                
                if promotion == nil {
                    promotion = PromotionModel(id: product_item.promotion!.id, name: product_item.promotion!.name, quantity: product_item.promotion!.quantity ?? 0, price: product_item.promotion!.price, forQuantity: product_item.promotion!.for_quantity)
                }
                
                products.append(ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, quantity: 0, product_id: product_item.id, price: product_item.price, weight: product_item.weight, promotion: promotion, description: product_item.description, favourite: product_item.favourite, avgRating: product_item.avg_rating, totalReviewsCount: product_item.total_reviews_count, parentCategoryId: product_item.parent_category_id, parentCategoryName: product_item.parent_category_name))
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
