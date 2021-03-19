//
//  ErrorResponseModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ErrorDataResponse: Decodable {
    var data: ErrorData
}

struct ErrorData: Decodable {
    var error: String
}
