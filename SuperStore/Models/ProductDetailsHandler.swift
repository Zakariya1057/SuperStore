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
    func errorHandler(_ message:String)
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
                    ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, quantity: 0, product_id: product_item.id, price: product_item.price, weight: product_item.weight, promotion: nil, description: product_item.description, favourite: product_item.favourite, avgRating: product_item.avg_rating, totalReviewsCount: product_item.total_reviews_count, parentCategoryId: product_item.parent_category_id, parentCategoryName: product_item.parent_category_name)
                )
            }
            
            let product = ProductDetailsModel(id: product_details.id, name: product_details.name, image: product_details.large_image, description: product_details.description, quantity: 0, price: product_details.price, avgRating: product_details.avg_rating, totalReviewsCount: product_details.total_reviews_count, promotion: promotion, storage: product_details.storage, weight: product_details.weight, parentCategoryId: product_details.parent_category_id, parentCategoryName: product_details.parent_category_name, dietary_info: product_details.dietary_info, allergen_info: product_details.allergen_info, brand: product_details.brand, reviews: reviews, favourite: product_details.favourite, ingredients: ingredients, recommended: recommended)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(product: product)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
