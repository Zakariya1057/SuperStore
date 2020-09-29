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
//    func errorHandler(_ message:String)
}


struct PromotionHandler {
        
    var delegate: PromotionDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(promotion_id: Int){
        let host_url = K.Host
        let promotion_path = K.Request.Grocery.Promotion
        let url_string = "\(host_url)/\(promotion_path)/\(promotion_id)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(PromotionDataResponse.self, from: data)
            let promotion_data = data.data
            
            var products:[ProductModel] = []
            
            for product_item in promotion_data.products ?? [] {
                products.append(ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, description: product_item.description, quantity: 0, weight: product_item.weight, parent_category_id: nil, parent_category_name: nil, price: product_item.price, location: "", avg_rating: product_item.avg_rating, total_reviews_count: product_item.total_reviews_count,discount: nil))
            }
            let promotion = PromotionModel(id: promotion_data.id, name: promotion_data.name, ends_at: promotion_data.ends_at,products: products)

            DispatchQueue.main.async {
                self.delegate?.contentLoaded(promotion: promotion)
            }


        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
