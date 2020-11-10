//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol ProductDetailsDelegate {
    func contentLoaded(product: ProductModel)
    func errorHandler(_ message:String)
    func logOutUser()
}

struct ProductDetailsHandler {
    
    var delegate: ProductDetailsDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(product_id: Int){
        let url_string = "\(K.Host)/\(K.Request.Grocery.Product)/\(product_id)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func requestMonitor(product_id: Int, userData: [String: String]){
        let url_string = "\(K.Host)/\(K.Request.Grocery.Product)/\(product_id)/\(K.Request.Grocery.ProductMonitor)"
        requestHandler.postRequest(url: url_string, data: userData, complete: { _ in },error:processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ProductDataResponse.self, from: data)
            let product_details = data.data
            
            let product_ingredients = product_details.ingredients
            
            var ingredients: [String] = []
            
            for ingredient in product_ingredients ?? [] {
                ingredients.append( ingredient.name)
            }
            
            var reviews: [ReviewModel] = []
            
            let date_format: DateFormatter = DateFormatter()
            date_format.dateFormat = "dd MMMM Y"
            
            for review in product_details.reviews ?? [] {
                reviews.append( ReviewModel(id: review.id, text: review.text, title: review.title, rating: review.rating, name: review.name, product_id: review.product_id, user_id: review.user_id, updated_at: date_format.date(from: review.updated_at)! , created_at: date_format.date(from: review.created_at)!) )
            }
            
            var promotion: PromotionModel? = nil

            if product_details.promotion != nil {
                promotion = PromotionModel(id: product_details.promotion!.id, name:  product_details.promotion!.name, quantity:  product_details.promotion!.quantity!, price: product_details.promotion!.price, forQuantity: product_details.promotion!.for_quantity)
            }
            
            var recommended: [ProductModel] = []
            
            for product_item in product_details.recommended ?? [] {
                recommended.append(
                    ProductModel(id: product_item.id, name: product_item.name, smallImage: product_item.small_image, largeImage: product_item.large_image, description: product_item.description, quantity: 0, price: product_item.price, avgRating: product_item.avg_rating, totalReviewsCount: product_item.total_reviews_count, promotion: nil, storage: product_item.storage, weight: product_item.weight, parentCategoryId: product_item.parent_category_id, parentCategoryName: product_item.parent_category_name, childCategoryName: nil, dietary_info: product_item.dietary_info, allergen_info: product_item.allergen_info, brand: product_item.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: [])
                )
            }
            
            let product = ProductModel(id: product_details.id, name: product_details.name, smallImage: product_details.small_image, largeImage: product_details.large_image, description: product_details.description, quantity: 0, price: product_details.price, avgRating: product_details.avg_rating, totalReviewsCount: product_details.total_reviews_count, promotion: promotion, storage: product_details.storage, weight: product_details.weight, parentCategoryId: product_details.parent_category_id, parentCategoryName: product_details.parent_category_name, childCategoryName: nil, dietary_info: product_details.dietary_info, allergen_info: product_details.allergen_info, brand: product_details.brand, reviews: reviews, favourite: product_details.favourite, monitoring: product_details.monitoring, ingredients: ingredients, recommended: recommended)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(product: product)
            }

        } catch {
            self.delegate?.errorHandler("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
