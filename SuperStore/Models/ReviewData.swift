//
//  ReviewData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ReviewsResponseData: Decodable {
    var data: [ReviewData]
}

struct ReviewData: Decodable {
    var id: Int
    var text: String
    var title: String
    var rating: Int
    var name: String?
}
