//
//  HomeAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class HomeAPI: API, HomeRequestProtocol {

    func getHome(regionID: Int, supermarketChainID: Int, latitude: Double?, longitude: Double?, completionHandler: @escaping (_ home: HomeModel?, _ error: String?) -> Void) {
        
        let homeData: Parameters = [
            "region_id": regionID,
            "supermarket_chain_id": supermarketChainID,
            "latitude": latitude ?? 0,
            "longitude": longitude ?? 0
        ]
        
        requestWorker.post(url: Config.Routes.Home, data: homeData) { (response: () throws -> Data) in
            do {
                let data = try response()
                let homeDataResponse =  try self.jsonDecoder.decode(HomeDataRespone.self, from: data)
                let home = self.createHomeModel(homeDataResponse: homeDataResponse, latitude: latitude, longitude: longitude)
                completionHandler(home, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to fetch home. Decoding error, please try again later.")
            }
        }
    }
}

extension HomeAPI {
    private func createHomeModel(homeDataResponse: HomeDataRespone?, latitude: Double?, longitude: Double?) -> HomeModel? {
        
        if let homeDataResponse = homeDataResponse {
            let homeData = homeDataResponse.data

            return HomeModel(
                lists: createListModel(listData: homeData.lists ?? []),
                stores:createStoresModel(storeData: homeData.stores ?? []),
                featured: createProductModel(productData: homeData.featured ?? []),
                groceries: createProductModel(productData: homeData.groceries ?? []),
                monitoring: createProductModel(productData: homeData.monitoring ?? []),
                promotions: createPromotionModel(promotionData: homeData.promotions ?? []),
                categories: createCategoriesModel(categoryData: homeData.categories),
                
                messages: createMessageModel(messageData: homeData.messages ?? []),
                
                latitude: latitude,
                longitude: longitude
            )
        }
        
        return nil
    }
    
}


extension HomeAPI {
    
    private func createCategoriesModel(categoryData: [ChildCategoryData]) -> [ChildCategoryModel]{
        
        var categories: [ChildCategoryModel] = []
        
        for category in categoryData {
            categories.append(category.getChildCategoryModel())
        }
        
        return categories
            
    }
    
    private func createPromotionModel(promotionData: [PromotionData]) -> [PromotionModel]{
        return promotionData.map { $0.getPromotionModel() }
    }
    
    private func createProductModel(productData: [ProductData]) -> [ProductModel]{
        return productData.map { $0.getProductModel() }
    }
    
    private func createListModel(listData: [ListData]) -> [ListModel] {
        return listData.map{ $0.getListModel() }
    }
    
    private func createStoresModel(storeData: [StoreData]) -> [StoreModel] {
        return storeData.map{ $0.getStoreModel() }
    }
    
    private func createMessageModel(messageData: [MessageData]) -> [MessageModel] {
        return messageData.map{ var message = $0.getMessaageModel(); message.read = false; return message }
    }
    
}
