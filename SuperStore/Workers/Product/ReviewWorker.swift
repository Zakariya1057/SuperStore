//
//  ReviewsWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ReviewWorker {
    var reviewAPI: ReviewRequestProtocol
    
    init(reviewAPI: ReviewRequestProtocol) {
        self.reviewAPI = reviewAPI
    }
    
    func getReviews(productID: Int, completionHandler: @escaping (_ reviews: [ReviewModel], _ error: String?) -> Void){
        reviewAPI.getReviews(productID: productID, completionHandler: completionHandler)
    }
    
    func getReview(productID: Int, completionHandler: @escaping (_ review: ReviewModel?, _ error: String?) -> Void){
        reviewAPI.getReview(productID: productID, completionHandler: completionHandler)
    }
    
    func deleteReview(productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        reviewAPI.deleteReview(productID: productID, completionHandler: completionHandler)
    }
    
    func createReview(review: ReviewModel, completionHandler: @escaping (_ error: String?) -> Void){
        reviewAPI.createReview(review: review, completionHandler: completionHandler)
    }

    func updateReview(review: ReviewModel, completionHandler: @escaping (_ error: String?) -> Void){
        reviewAPI.updateReview(review: review, completionHandler: completionHandler)
    }
}

protocol ReviewRequestProtocol {
    func getReview(productID: Int, completionHandler: @escaping (_ review: ReviewModel?, _ error: String?) -> Void)
    func getReviews(productID: Int, completionHandler: @escaping (_ reviews: [ReviewModel], _ error: String?) -> Void)
    func updateReview(review: ReviewModel, completionHandler: @escaping (String?) -> Void)
    func createReview(review: ReviewModel, completionHandler: @escaping (String?) -> Void)
    func deleteReview(productID: Int, completionHandler: @escaping (String?) -> Void)
}
