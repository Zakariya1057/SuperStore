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
                let productDataResponse =  try self.jsonDecoder.decode(ProductDataResponse.self, from: data)
                let product = self.createProductModel(productDataResponse: productDataResponse)
                completionHandler(product, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to get product. Decoding error, please try again later.")
            }
        }
    }
    
    func updateMonitor(productID: Int, monitor: Bool, completionHandler: @escaping (String?) -> Void){
        let url = Config.Route.Product.Show + String(productID) + Config.Route.Product.Monitor
        
        requestWorker.post(url: url, data: ["monitor": monitor]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to update monitor. Decoding error, please try again later.")
            }
        }
    }
    
}

extension ProductAPI {
    
    private func createProductModel(productDataResponse: ProductDataResponse?) -> ProductModel? {
        
        if let productDataResponse = productDataResponse {
            let productData = productDataResponse.data
            return productData.getProductModel()
        }
        
        return nil
    }
}
