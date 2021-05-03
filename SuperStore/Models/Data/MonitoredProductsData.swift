//
//  MonitoredProductsData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct MonitoredProductsDataResponse: Decodable {
    var data: [ProductData]
}
