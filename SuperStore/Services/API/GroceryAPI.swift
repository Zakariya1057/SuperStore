//
//  GroceryAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class GroceryAPI: GroceryRequestProtocol {

    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
    
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ([GrandParentCategoryModel], String?) -> Void) {
        let url: String = Config.Route.Grocery.GrandParentCategories + "/" + String(storeTypeID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let grandParentCategoryDataResponse =  try self.jsonDecoder.decode(GrandParentCategoriesDataResponse.self, from: data)
                let categories = self.createGrandParentCategoriesModel(grandParentCategoryDataResponse: grandParentCategoryDataResponse)
                completionHandler(categories, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get product. Decoding error, please try again later.")
            }
        }
    }
    
    func getChildCategories(grandParentCategoryID: Int, completionHandler: @escaping ([ChildCategoryModel], String?) -> Void){
        let url: String = Config.Route.Grocery.ChildCategories + "/" + String(grandParentCategoryID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let childCategoryDataResponse =  try self.jsonDecoder.decode(ChildCategoriesDataResponse.self, from: data)
                let categories = self.createChildCategoriesModel(childCategoryDataResponse: childCategoryDataResponse)
                completionHandler(categories, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get product. Decoding error, please try again later.")
            }
        }
    }
}

extension GroceryAPI {
    private func createGrandParentCategoriesModel(grandParentCategoryDataResponse: GrandParentCategoriesDataResponse) -> [GrandParentCategoryModel] {
        let categoryData = grandParentCategoryDataResponse.data
        let categories: [GrandParentCategoryModel] = categoryData.map { (category: GrandParentCategoryData) in
            return category.getParentCategoryModel()
        }
        
        return categories
    }
    
    private func createChildCategoriesModel(childCategoryDataResponse: ChildCategoriesDataResponse) -> [ChildCategoryModel] {
        let categoryData = childCategoryDataResponse.data
        let categories: [ChildCategoryModel] = categoryData.map { (category: ChildCategoryData) in
            return category.getChildCategoryModel()
        }
        
        return categories
    }
}
