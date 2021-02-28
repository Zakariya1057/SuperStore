//
//  HomeAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class HomeAPI: HomeRequestProtocol {

    let jsonDecoder = JSONDecoder()
    
    let requestWorker: RequestProtocol = RequestWorker()

    func getHome(completionHandler: @escaping (_ home: HomeModel?, _ error: String?) -> Void) {
        requestWorker.get(url: Config.Route.Home) { (response: () throws -> Data) in
            do {
                let data = try response()
                let homeResponseData =  try self.jsonDecoder.decode(HomeResponeData.self, from: data)
                let home = self.createHomeModel(homeResponseData: homeResponseData)
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
    private func createHomeModel(homeResponseData: HomeResponeData?) -> HomeModel? {
        
        if let homeResponseData = homeResponseData {
            let homeData = homeResponseData.data

            return HomeModel(
                lists: createListModel(listData: homeData.lists ?? []),
                stores:createStoresModel(storeData: homeData.stores ?? []),
                featured: createProductModel(productData: homeData.featured ?? []),
                groceries: createProductModel(productData: homeData.groceries ?? []),
                monitoring: createProductModel(productData: homeData.monitoring ?? []),
                promotions: createPromotionModel(promotionData: homeData.promotions ?? []),
                categories: createCategoriesModel(categoryData: homeData.categories ?? [:])
            )
        }
        
        return nil
    }
    
    private func createCategoriesModel(categoryData: [String : [ProductData]]) -> [String: [ProductModel]]{
        
        var categories: [String: [ProductModel]] = [:]
        
        for category in categoryData {
            let categoryName:String = category.key
            let products:[ProductModel] = createProductModel(productData: category.value)

            categories[categoryName] = products
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
}
