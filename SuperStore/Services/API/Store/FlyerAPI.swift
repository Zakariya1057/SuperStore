//
//  FlyerAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FlyerAPI: API, FlyerRequestProtocol {
    func getFlyers(storeID: Int, completionHandler: @escaping ([FlyerModel], String?) -> Void) {
        let url = Config.Routes.Flyers.Show + String(storeID)
        
        requestWorker.get(url:url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let flyersDataResponse =  try self.jsonDecoder.decode(FlyersDataResponse.self, from: data)
                let flyers = self.createFlyerModels(flyersDataResponse: flyersDataResponse)
                completionHandler(flyers, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get flyers. Decoding error, please try again later.")
            }
        }
    }
    
    func getFlyerProducts(flyerID: Int, completionHandler: @escaping ([ProductModel], String?) -> Void) {
        let url = Config.Routes.Flyers.Products + String(flyerID)
        
        requestWorker.get(url:url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let productsDataResponse =  try self.jsonDecoder.decode(ProductsDataResponse.self, from: data)
                let products = self.createProductModels(productsDataResponse: productsDataResponse)
                completionHandler(products, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get products. Decoding error, please try again later.")
            }
        }
    }
}

extension FlyerAPI {
    private func createFlyerModels(flyersDataResponse: FlyersDataResponse) -> [FlyerModel] {
        let flyersData: [FlyerData] = flyersDataResponse.data
        return flyersData.map { (flyer: FlyerData) in
            return flyer.getFlyerModel()
        }
    }
    
    private func createProductModels(productsDataResponse: ProductsDataResponse) -> [ProductModel] {
        let productsData = productsDataResponse.data
        return productsData.map{ $0.getProductModel() }
    }
}
