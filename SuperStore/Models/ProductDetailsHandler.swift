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
    
    func request(productID: Int){
        let urlString = "\(K.Host)/\(K.Request.Grocery.Product)/\(productID)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func requestMonitor(productID: Int, userData: [String: String]){
        let urlString = "\(K.Host)/\(K.Request.Grocery.Product)/\(productID)/\(K.Request.Grocery.ProductMonitor)"
        requestHandler.postRequest(url: urlString, data: userData, complete: { _ in },error:processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ProductDataResponse.self, from: data)
            let productDetails = data.data
            
            let productIngredients = productDetails.ingredients
            
            var ingredients: [String] = []
            
            for ingredient in productIngredients ?? [] {
                ingredients.append( ingredient.name)
            }
            
            var reviews: [ReviewModel] = []
            
            let dateFormat: DateFormatter = DateFormatter()
            dateFormat.dateFormat = "dd MMMM Y"
            
            for review in productDetails.reviews ?? [] {
                reviews.append( ReviewModel(id: review.id, text: review.text, title: review.title, rating: review.rating, name: review.name, productID: review.product_id, userID: review.user_id, updatedAt: dateFormat.date(from: review.updated_at)! , createdAt: dateFormat.date(from: review.created_at)!) )
            }
            
            var promotion: PromotionModel? = nil

            if productDetails.promotion != nil {
                promotion = PromotionModel(id: productDetails.promotion!.id, name:  productDetails.promotion!.name, quantity:  productDetails.promotion!.quantity!, price: productDetails.promotion!.price, forQuantity: productDetails.promotion!.for_quantity)
            }
            
            var recommended: [ProductModel] = []
            
            for productItem in productDetails.recommended ?? [] {
                recommended.append(
                    ProductModel(id: productItem.id, name: productItem.name, smallImage: productItem.small_image, largeImage: productItem.large_image, description: productItem.description, quantity: 0, price: productItem.price, avgRating: productItem.avg_rating, totalReviewsCount: productItem.total_reviews_count, promotion: nil, storage: productItem.storage, weight: productItem.weight, parentCategoryId: productItem.parent_category_id, parentCategoryName: productItem.parent_category_name, childCategoryName: nil, dietaryInfo: productItem.dietary_info, allergenInfo: productItem.allergen_info, brand: productItem.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: [])
                )
            }
            
            let product = ProductModel(id: productDetails.id, name: productDetails.name, smallImage: productDetails.small_image, largeImage: productDetails.large_image, description: productDetails.description, quantity: 0, price: productDetails.price, avgRating: productDetails.avg_rating, totalReviewsCount: productDetails.total_reviews_count, promotion: promotion, storage: productDetails.storage, weight: productDetails.weight, parentCategoryId: productDetails.parent_category_id, parentCategoryName: productDetails.parent_category_name, childCategoryName: nil, dietaryInfo: productDetails.dietary_info, allergenInfo: productDetails.allergen_info, brand: productDetails.brand, reviews: reviews, favourite: productDetails.favourite, monitoring: productDetails.monitoring, ingredients: ingredients, recommended: recommended)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(product: product)
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
