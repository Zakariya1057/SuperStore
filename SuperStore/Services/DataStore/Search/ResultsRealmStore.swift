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
    
    func searchResults(query: ProductQueryModel) -> ProductResultsModel {
        
        let type: String = query.type.lowercased()
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
            products = productSearch(query: query)
        } else if type == "child_categories" {
            products = childCategorySearch(query: query)
        } else if type == "parent_categories" {
            products = parentCategorySearch(query: query)
        }

        return ProductResultsModel(products: products)
    }
    
}

extension ProductResultsRealmStore {
    private func productSearch(query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self).filter("name contains[c] %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
    
    private func childCategorySearch(query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self).filter("childCategoryName = %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
    
    private func parentCategorySearch(query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self).filter("parentCategoryName = %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
}

extension ProductResultsRealmStore {
    func parseResults(results: Results<ProductObject>?) -> [ProductModel]{
        return results?.map{ $0.getProductModel() } ?? []
    }
}
