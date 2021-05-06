//
//  API.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class API {
    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
}
