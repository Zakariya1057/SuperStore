//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol ProductDetailsDelegate {
    func contentLoaded(product: ProductDetailsModel)
//    func errorHandler(_ message:String)
}

struct ProductDetailsHandler {
    
    var delegate: ProductDetailsDelegate?
    
    let requestHandler = RequestHandler()
    
    let productPath = K.Request.Grocery.Product
    
    func request(product_id: Int){
        let url_string = "\(K.Host)/\(productPath)/\(product_id)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ProductDataResponse.self, from: data)
            let product_details = data.data
            
            let promotion_details = product_details.promotion
            let product_ingredients = product_details.ingredients
            
            var ingredients: [String] = []
            
            for ingredient in product_ingredients ?? [] {
                ingredients.append( ingredient.name)
            }
            
            var reviews: [ReviewModel] = []
            
            for review in product_details.reviews ?? [] {
                reviews.append( ReviewModel(id: review.id, text: review.text, title: review.title, rating: review.rating, name: review.name!) )
            }
            
            var promotion:PromotionModel? = nil
            
            if promotion_details != nil {
                promotion = PromotionModel(id: promotion_details!.id, name: promotion_details!.name, ends_at: promotion_details!.ends_at)
            }

            var recommended: [ProductModel] = []
            
            for product_item in product_details.recommended ?? [] {
                recommended.append(ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, description: product_item.description, quantity: 0,weight: product_item.weight, parent_category_id: nil, parent_category_name: nil, price: product_item.price, location: "", avg_rating: 1, total_reviews_count: 1,discount: nil))
            }
            
            let product = ProductDetailsModel(id: product_details.id, name: product_details.name, image: product_details.large_image, description: product_details.description, quantiy: 0, price: product_details.price, location: "",avg_rating: product_details.avg_rating, total_reviews_count: product_details.total_reviews_count, storage: product_details.storage, weight: product_details.weight, parent_category_id: nil, parent_category_name: nil, dietary_info: product_details.dietary_info, allergen_info: product_details.allergen_info, brand: product_details.brand, reviews: reviews, favourite: product_details.favourite!, promotion: promotion, ingredients: ingredients, recommended: recommended )
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(product: product)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
