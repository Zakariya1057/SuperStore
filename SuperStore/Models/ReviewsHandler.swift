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
    func errorHandler(_ message:String)
    func logOutUser()
}

struct ReviewsHandler {
    
    var delegate: ReviewsListDelegate?
    
    let requestHandler = RequestHandler()
    
    let productPath = K.Request.Grocery.Product
    let reviewsPath = K.Request.Reviews.Reviews
    let reviewPath = K.Request.Reviews.ReviewShow
    let reviewCreatePath = K.Request.Reviews.ReviewCreate
    let reviewDeletePath = K.Request.Reviews.ReviewDelete
    
    func index(productID: Int){
        let urlString = "\(K.Host)/\(productPath)/\(productID)/\(reviewsPath)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func show(productID: Int){
        let urlString = "\(K.Host)/\(productPath)/\(productID)/\(reviewPath)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func create(productID: Int, reviewData: [String: String]){
        let urlString = "\(K.Host)/\(productPath)/\(productID)/\(reviewCreatePath)"
        requestHandler.postRequest(url: urlString, data: reviewData, complete: processResults, error: processError,logOutUser: logOutUser)
    }
    
    func delete(productID: Int){
        let urlString = "\(K.Host)/\(productPath)/\(productID)/\(reviewDeletePath)"
        requestHandler.postRequest(url: urlString, data: ["product_id": String(productID)], complete: processResponse, error: processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ReviewsResponseData.self, from: data)
            let reviews_list = data.data
            
            var reviews:[ReviewModel] = []
            
            let date_format: DateFormatter = DateFormatter()
            date_format.dateFormat = "dd MMMM Y"
            
            for review in reviews_list {
                reviews.append( ReviewModel(id: review.id, text: review.text, title: review.title, rating: review.rating, name: review.name, productID: review.product_id, userID: review.user_id, updatedAt: date_format.date(from: review.updated_at)! , createdAt: date_format.date(from: review.created_at)!))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(reviews: reviews)
            }

        } catch {
            processError("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processResponse(_ data:Data){
        DispatchQueue.main.async {
            self.delegate?.contentLoaded(reviews: [])
        }
    }
    
    
    func processError(_ message:String){
        print(message)
        self.delegate?.errorHandler(message)
    }
}
