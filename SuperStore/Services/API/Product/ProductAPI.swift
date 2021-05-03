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
    
}

extension ProductAPI {
    
    func getMonitoredProducts(storeTypeID: Int, completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void){
        let url = Config.Route.Monitor.Products
        
        requestWorker.post(url: url, data: ["store_type_id": storeTypeID]) { (response: () throws -> Data) in
            do {
                let data = try response()
                let productDataResponse =  try self.jsonDecoder.decode(MonitoredProductsDataResponse.self, from: data)
                let products = self.createProductModel(productsDataResponse: productDataResponse)
                completionHandler(products, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get monitored products. Decoding error, please try again later.")
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
    
    private func createProductModel(productsDataResponse: MonitoredProductsDataResponse) -> [ProductModel] {
        return productsDataResponse.data.map{ $0.getProductModel() }
    }
    
    private func createProductModel(productDataResponse: ProductDataResponse) -> ProductModel {
        let productData = productDataResponse.data
        return productData.getProductModel()
    }
}
