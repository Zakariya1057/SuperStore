//
//  ReviewRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ReviewRealmStore: DataStore, ReviewSaveProtocol {
    
    private func getReviewObject(productID: Int, userID: Int) -> ReviewObject? {
        return realm?.objects(ReviewObject.self).filter("productID = %@ AND userID = %@", productID, userID).first
    }
    
    private func getReviewObject(reviewID: Int) -> ReviewObject? {
        return realm?.objects(ReviewObject.self).filter("id = %@", reviewID).first
    }
    
    
    func getReview(productID: Int, userID: Int) -> ReviewModel? {
        let savedReview = getReviewObject(productID: productID, userID: userID)
        return savedReview?.getReviewModel()
    }
    
    func getReviews(productID: Int) -> [ReviewModel] {
        if let savedReviews = realm?.objects(ReviewObject.self).filter("productID = %@", productID).sorted(byKeyPath: "updatedAt",ascending: true) {
            return savedReviews.map{ $0.getReviewModel() }
        }
        
        return []
    }
    
    func createReviews(reviews: [ReviewModel]) {
        for review in reviews {
            createReview(review: review)
        }
    }
    
    func createReview(review: ReviewModel){
        
        if let savedReview = getReviewObject(reviewID: review.id) {
            updateSavedReview(review: review, savedReview: savedReview)
            return
        }
        
        try? realm?.write({
            let savedReview = createReviewObject(review: review)
            realm?.add(savedReview)
        })
    }
    
    func updateReview(review: ReviewModel) {
        if let savedReview = getReviewObject(productID: review.productID, userID: review.userID) {
            try? realm?.write({
                savedReview.rating = review.rating
                savedReview.title = review.title
                savedReview.text = review.text
            })
        }
    }
    
    func deleteReview(reviewID: Int) {
        if let review = getReviewObject(reviewID: reviewID) {
            try? realm?.write({
                realm?.delete(review)
            })
        }
    }
}

extension ReviewRealmStore {
    func createReviewObject(review: ReviewModel) -> ReviewObject {
        
        if let savedReview = getReviewObject(reviewID: review.id){
            return savedReview
        }
        
        let savedReview = ReviewObject()
        
        savedReview.id = review.id
        savedReview.userID = review.userID
        savedReview.name = review.name
        savedReview.productID = review.productID
        
        savedReview.rating = review.rating
        savedReview.title = review.title
        savedReview.text = review.text
        
        return savedReview
    }
    
    func updateSavedReview(review: ReviewModel, savedReview: ReviewObject){
        try? realm?.write({
            savedReview.name = review.name
            savedReview.userID = review.userID
            savedReview.productID = review.productID
            
            savedReview.rating = review.rating
            savedReview.title = review.title
            savedReview.text = review.text
            
            savedReview.updatedAt = Date()
        })
    }
}
