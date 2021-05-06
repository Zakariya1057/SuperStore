//
//  GroceryAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class GroceryAPI: API, GroceryRequestProtocol {
    
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ([GrandParentCategoryModel], String?) -> Void) {
        let url: String = Config.Route.Groceries.GrandParentCategories + "/" + String(storeTypeID)
        
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
                completionHandler([], "Failed to get categories. Decoding error, please try again later.")
            }
        }
    }
    
    func getChildCategories(parentCategoryID: Int, completionHandler: @escaping ([ChildCategoryModel], String?) -> Void){
        let url: String = Config.Route.Groceries.ChildCategories + "/" + String(parentCategoryID)
        
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
                completionHandler([], "Failed to get categories. Decoding error, please try again later.")
            }
        }
    }
    
    
    func getCategoryProducts(childCategoryID: Int, data: SearchQueryRequest, page: Int, completionHandler: @escaping (ChildCategoryModel?, String?) -> Void){
        let url: String = Config.Route.Groceries.CategoryProducts + "/" + String(childCategoryID)  + "?page=\(page)"
        
        let queryData: Parameters = [
            "sort": data.sort,
            "order": data.order,
            "dietary": data.dietary,
            "brand": data.brand,
            "promotion": data.promotion
        ]
        
        requestWorker.post(url: url, data: queryData) { (response: () throws -> Data) in
            do {
                let data = try response()
                let categoryProductsDataResponse =  try self.jsonDecoder.decode(CategoryProductsDataResponse.self, from: data)
                let categoryProducts = self.createChildCategoriesModel(categoryProductsDataResponse: categoryProductsDataResponse)
                completionHandler(categoryProducts, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to get category products. Decoding error, please try again later.")
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
    
    private func createChildCategoriesModel(categoryProductsDataResponse: CategoryProductsDataResponse) -> ChildCategoryModel? {
        if let categoryProducts = categoryProductsDataResponse.data {
            return categoryProducts.getChildCategoryModel()
        }
        
        return nil
    }
}
