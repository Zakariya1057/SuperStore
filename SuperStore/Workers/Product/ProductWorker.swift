//
//  ProductWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductWorker {
    var productAPI: ProductRequestProtocol
    
    init(productAPI: ProductRequestProtocol) {
        self.productAPI = productAPI
    }
    
    func getProduct(productID: Int, completionHandler: @escaping (_ product: ProductModel?, _ error: String?) -> Void){
        productAPI.getProduct(productID: productID, completionHandler: completionHandler)
    }
}

protocol ProductRequestProtocol {
    func getProduct(productID: Int, completionHandler: @escaping (_ product: ProductModel?, _ error: String?) -> Void)
}
