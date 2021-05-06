//
//  ReviewsWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ReviewWorker {
    private var reviewAPI: ReviewRequestProtocol
    private var reviewStore: ReviewSaveProtocol
    
    init(reviewAPI: ReviewRequestProtocol) {
        self.reviewAPI = reviewAPI
        self.reviewStore = ReviewRealmStore()
    }
    
    func getReviews(productID: Int, completionHandler: @escaping (_ reviews: [ReviewModel], _ error: String?) -> Void){
        
        let reviews = reviewStore.getReviews(productID: productID)
        if reviews.count > 0 {
            completionHandler(reviews, nil)
        }
        
        reviewAPI.getReviews(productID: productID) { (reviews: [ReviewModel], error: String?) in
            self.reviewStore.createReviews(reviews: reviews)
            completionHandler(reviews, error)
        }
    }
    
    func getReview(productID: Int, userID: Int, completionHandler: @escaping (_ review: ReviewModel?, _ error: String?) -> Void){
        
        if let review = reviewStore.getReview(productID: productID, userID: userID) {
            completionHandler(review, nil)
        }
        
        reviewAPI.getReview(productID: productID) { (review: ReviewModel?, error: String?) in
            if let review = review {
                self.reviewStore.createReview(review: review)
            }
           
            completionHandler(review, error)
        }
    }
    
    func deleteReview(reviewID: Int, productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        reviewStore.deleteReview(reviewID: reviewID)
        reviewAPI.deleteReview(productID: productID, completionHandler: completionHandler)
    }
    
    func createReview(review: ReviewModel, completionHandler: @escaping (_ error: String?) -> Void){
        reviewAPI.createReview(review: review) { (review: ReviewModel?, error: String?) in
            if let review = review {
                self.reviewStore.createReview(review: review)
            }
            
            completionHandler(error)
        }
    }

    func updateReview(review: ReviewModel, completionHandler: @escaping (_ error: String?) -> Void){
        reviewAPI.updateReview(review: review) { (error: String?) in
            if error == nil {
                self.reviewStore.updateReview(review: review)
            }
            
            completionHandler(error)
        }
    }
}

protocol ReviewRequestProtocol {
    func getReview(productID: Int, completionHandler: @escaping (_ review: ReviewModel?, _ error: String?) -> Void)
    func getReviews(productID: Int, completionHandler: @escaping (_ reviews: [ReviewModel], _ error: String?) -> Void)
    func updateReview(review: ReviewModel, completionHandler: @escaping (String?) -> Void)
    func createReview(review: ReviewModel, completionHandler: @escaping (_ review: ReviewModel?, String?) -> Void)
    func deleteReview(productID: Int, completionHandler: @escaping (String?) -> Void)
}

protocol ReviewSaveProtocol {
    func getReviews(productID: Int) -> [ReviewModel]
    func getReview(productID: Int, userID: Int) -> ReviewModel?
    
    func updateReview(review: ReviewModel)
    
    func createReviews(reviews: [ReviewModel]) -> Void
    func createReview(review: ReviewModel) -> Void
    
    func deleteReview(reviewID: Int) -> Void
}
