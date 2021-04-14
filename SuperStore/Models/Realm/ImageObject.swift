//
//  ImageObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 13/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ImageObject: Object {
    @objc dynamic var productID: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var size: String = ""
    
    @objc dynamic var enabled: Bool = true
    
    func getImageModel() -> ImageModel {
        return ImageModel(productID: productID, name: name, size: size)
    }
}
