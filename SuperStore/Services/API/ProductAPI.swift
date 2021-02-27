//
//  ProductAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductAPI: ProductRequestProtocol {
    
    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
    
    func getProduct(productID: Int, completionHandler: @escaping (ProductModel?, String?) -> Void) {
        let url = Config.Route.Product.Show + String(productID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let productResponseData =  try? self.jsonDecoder.decode(ProductDataResponse.self, from: data)
                let product = self.createProductModel(productResponseData: productResponseData)
                completionHandler(product, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                completionHandler(nil, "Failed To Fetch Home. Please try again later.")
            }
        }
    }
    
}

extension ProductAPI {
    
    private func createProductModel(productResponseData: ProductDataResponse?) -> ProductModel? {
        
        if let productResponseData = productResponseData {
            let productData = productResponseData.data
            return productData.getProductModel()
        }
        
        return nil
    }
}
