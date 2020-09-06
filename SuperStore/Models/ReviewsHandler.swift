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
    
    func request(product_id: Int){
        let host_url = K.Host
        let product_path = K.Request.Grocery.Product
        let reviews_path = K.Request.Grocery.Reviews
        let url_string = "\(host_url)/\(product_path)/\(product_id)/\(reviews_path)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ReviewsResponseData.self, from: data)
            let reviews_list = data.data
            
            var reviews:[ReviewModel] = []
            
            for review in reviews_list {
                reviews.append( ReviewModel(id: review.id, text: review.text, title: review.title, rating: review.rating, name: review.name))
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
