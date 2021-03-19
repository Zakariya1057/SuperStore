//
//  ResultsRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 11/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductResultsRealmStore: DataStore, ProductResultsStoreProtocol {
    var productStore: ProductStoreProtocol = ProductRealmStore()
    
    func createResults(results: ProductResultsModel){
        productStore.createProducts(products: results.products)
    }
    
    func searchResults(query: SearchQueryRequest) -> ProductResultsModel {
        
        let type: String = query.type.lowercased()
        let storeTypeID: Int = query.storeTypeID
        let query: String = query.query
        
        var products: [ProductModel] = []
        
//        var query: String
//        var type: String
//        var sort: String = ""
//        var order: String = ""
//        var dietary: String = ""
//        var brand: String = ""
//        var childCategory: String = ""
//        var textSearch: Bool = false
        
        if type == "products" {
            products = productSearch(storeTypeID:storeTypeID, query: query)
        } else if type == "child_categories" {
            products = childCategorySearch(storeTypeID:storeTypeID, query: query)
        } else if type == "parent_categories" {
            products = parentCategorySearch(storeTypeID:storeTypeID, query: query)
        }

        return ProductResultsModel(products: products, paginate: nil)
    }
    
}

extension ProductResultsRealmStore {
    private func productSearch(storeTypeID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self).filter("storeTypeID = %@ AND name contains[c] %@ AND childCategoryName != nil", storeTypeID, query)
        return parseResults(results: productResults)
    }
    
    private func childCategorySearch(storeTypeID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self).filter("storeTypeID = %@ AND childCategoryName = %@ AND childCategoryName != nil", storeTypeID, query)
        return parseResults(results: productResults)
    }
    
    private func parentCategorySearch(storeTypeID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self).filter("storeTypeID = %@ AND parentCategoryName = %@ AND childCategoryName != nil", storeTypeID, query)
        return parseResults(results: productResults)
    }
}

extension ProductResultsRealmStore {
    func parseResults(results: Results<ProductObject>?) -> [ProductModel]{
        return results?.map{ $0.getProductModel() } ?? []
    }
}
