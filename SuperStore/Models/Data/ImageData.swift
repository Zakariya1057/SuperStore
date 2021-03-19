//
//  ImageData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 13/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ImageData: Decodable {
    var product_id: Int
    var name: String
    var size: String
    
    func getImageModel() -> ImageModel {
        return ImageModel(productID: product_id, name: name, size: size)
    }
}
