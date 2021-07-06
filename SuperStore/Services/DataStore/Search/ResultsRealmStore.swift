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
        let supermarketChainID: Int = query.supermarketChainID
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
            products = productSearch(supermarketChainID:supermarketChainID, query: query)
        } else if type == "child_categories" {
            products = childCategorySearch(supermarketChainID:supermarketChainID, query: query)
        } else if type == "parent_categories" {
            products = parentCategorySearch(supermarketChainID:supermarketChainID, query: query)
        } else if type == "promotions" {
            products = promotionSearch(supermarketChainID:supermarketChainID, query: query)
        } else if type == "brands" {
            products = brandSearch(supermarketChainID:supermarketChainID, query: query)
        }

        return ProductResultsModel(products: products, paginate: nil)
    }
    
}

extension ProductResultsRealmStore {
    private func productSearch(supermarketChainID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self)
            .filter("name contains[c] %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
    
    private func brandSearch(supermarketChainID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self)
            .filter("brand contains[c] %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
    
    private func childCategorySearch(supermarketChainID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self)
            .filter("childCategoryName = %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
    
    private func parentCategorySearch(supermarketChainID: Int, query: String) -> [ProductModel]{
        let productResults = realm?.objects(ProductObject.self)
            .filter("parentCategoryName = %@ AND childCategoryName != nil", query)
        return parseResults(results: productResults)
    }
    
    private func promotionSearch(supermarketChainID: Int, query: String) -> [ProductModel]{
        return realm?.objects(PromotionObject.self)
            .filter("name = %@", supermarketChainID, query)
            .first?.products.map{ $0.getProductModel() }.compactMap ({ $0 }) ?? []
    }
}

extension ProductResultsRealmStore {
    func parseResults(results: Results<ProductObject>?) -> [ProductModel]{
        return results?.map{ $0.getProductModel() }.compactMap({ $0 }) ?? []
    }
}
