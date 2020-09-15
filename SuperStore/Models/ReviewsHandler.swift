//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol ReviewsListDelegate {
    func contentLoaded(reviews: [ReviewModel])
//    func errorHandler(_ message:String)
}

struct ReviewsHandler {
    
    var delegate: ReviewsListDelegate?
    
    let requestHandler = RequestHandler()
    
    let productPath = K.Request.Grocery.Product
    let reviewsPath = K.Request.Grocery.Reviews
    let reviewPath = K.Request.Grocery.ReviewShow
    let reviewCreatePath = K.Request.Grocery.ReviewCreate
    let reviewDeletePath = K.Request.Grocery.ReviewDelete
    
    func index(product_id: Int){
        let url_string = "\(K.Host)/\(productPath)/\(product_id)/\(reviewsPath)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func show(product_id: Int){
        let url_string = "\(K.Host)/\(productPath)/\(product_id)/\(reviewPath)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func create(product_id: Int, review_data: [String: String]){
        let url_string = "\(K.Host)/\(productPath)/\(product_id)/\(reviewCreatePath)"
        requestHandler.postRequest(url: url_string, data: review_data, complete: { _ in }, error: processError)
    }
    
    func delete(product_id: Int){
        let url_string = "\(K.Host)/\(productPath)/\(product_id)/\(reviewDeletePath)"
        requestHandler.postRequest(url: url_string, data: ["product_id": String(product_id)], complete: { _ in }, error: processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ReviewsResponseData.self, from: data)
            let reviews_list = data.data
            
            var reviews:[ReviewModel] = []
            
            for review in reviews_list {
                reviews.append( ReviewModel(id: review.id, text: review.text, title: review.title, rating: review.rating, name: review.name ?? ""))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(reviews: reviews)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
