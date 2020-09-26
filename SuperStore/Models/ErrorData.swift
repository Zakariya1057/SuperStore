//
//  ErrorData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
struct ErrorDataResponse: Decodable {
    var data: ErrorData
}

struct ErrorData: Decodable {
    var error: String
}
