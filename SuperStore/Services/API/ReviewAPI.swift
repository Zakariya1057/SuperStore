//
//  ReviewAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ReviewAPI: ReviewRequestProtocol {

    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
    
    func getReview(productID: Int, completionHandler: @escaping (ReviewModel?, String?) -> Void) {
        
    }
    
    func getReviews(productID: Int, completionHandler: @escaping ([ReviewModel], String?) -> Void) {
        
        let url = Config.Route.Product.Show + String(productID) + Config.Route.Product.Review.All
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let reviewDataResponse =  try self.jsonDecoder.decode(ReviewsDataResponse.self, from: data)
                let reviews = self.createReviewModels(reviewsDataResponse: reviewDataResponse)
                completionHandler(reviews, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get reviews. Decoding error, please try again later.")
            }
        }
        
    }
    

    
}

extension ReviewAPI {

    private func createReviewModels(reviewsDataResponse: ReviewsDataResponse?) -> [ReviewModel] {
        
        var reviews: [ReviewModel] = []
        
        if let reviewsDataResponse = reviewsDataResponse {
            for reviewData in reviewsDataResponse.data {
                reviews.append(reviewData.getReviewModel())
            }
        }
        
        return reviews
    }
    
    private func createReviewModel(reviewDataResponse: ReviewDataResponse?) -> ReviewModel? {
        
        if let reviewDataResponse = reviewDataResponse {
            let reviewData = reviewDataResponse.data
            
            if let reviewData = reviewData {
                return reviewData.getReviewModel()
            }
           
        }
        
        return nil
    }
}
