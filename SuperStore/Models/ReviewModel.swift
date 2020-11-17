//
//  ReviewModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ReviewModel {
    var id: Int
    var text: String
    var title: String
    var rating: Int
    var name: String
    var productID: Int
    var userID: Int
    var updatedAt: Date
    var createdAt: Date
    
    func getRealmObject() -> ReviewHistory {
        let review = ReviewHistory()
        review.id = self.id
        review.text = self.text
        review.title = self.title
        review.name = self.name
        review.rating = self.rating
        review.productID = self.productID
        review.userID = self.userID
        review.updatedAt = self.updatedAt
        review.createdAt = self.createdAt
        return review
    }
}
