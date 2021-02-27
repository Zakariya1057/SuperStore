//
//  ReviewData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
struct ReviewResponseData: Decodable {
    var data: ReviewData?
}

struct ReviewData: Decodable {
    var id: Int
    var text: String
    var title: String
    var rating: Int
    var name: String
    var product_id: Int
    var user_id: Int
    var updated_at: String
    var created_at: String
    
    func getReviewModel() -> ReviewModel {
        
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "dd MMMM Y"
        
        let createdDate: Date = dateFormat.date(from: created_at)!
        let updatedData: Date = dateFormat.date(from: updated_at)!
        
        return ReviewModel(
            id: id,
            text: text,
            title: title,
            rating: rating,
            name: name,
            productID: product_id,
            userID: user_id,
            updatedAt: updatedData,
            createdAt: createdDate
        )
    }
}
