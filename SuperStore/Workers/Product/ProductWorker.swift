//
//  ProductWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductWorker {
    private var productAPI: ProductRequestProtocol
    private var productStore: ProductStoreProtocol
    
    init(productAPI: ProductRequestProtocol) {
        self.productAPI = productAPI
        self.productStore = ProductRealmStore()
    }
    
    func getProduct(regionID: Int, supermarketChainID: Int, productID: Int, completionHandler: @escaping (_ product: ProductModel?, _ error: String?) -> Void){
        
        if let product = productStore.getProduct(regionID: regionID, supermarketChainID: supermarketChainID, productID: productID){
            completionHandler(product, nil)
        }
        
        productAPI.getProduct(regionID: regionID, supermarketChainID: supermarketChainID, productID: productID) { (product: ProductModel?, error: String?) in
            if let product = product {
                // Remove expired promotion
                // Remove expired sale
                self.productStore.createProduct(product: product)
            }
            
            completionHandler(product, error)
        }
    }

}

extension ProductWorker {
    
    func getMonitoredProducts(regionID: Int, supermarketChainID: Int, completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void){
        let products = productStore.getMonitoredProducts(regionID: regionID, supermarketChainID: supermarketChainID)
        
        if products.count > 0 {
            completionHandler(products, nil)
        }
        
        productAPI.getMonitoredProducts(regionID: regionID, supermarketChainID: supermarketChainID) { (products: [ProductModel], error: String?) in
            if error == nil {
                self.productStore.unmonitorAllProducts()
                self.productStore.createProducts(products: products)
            }
            
            completionHandler(products, nil)
        }
    }
    
    func updateMonitor(productID: Int, monitor: Bool, completionHandler: @escaping (String?) -> Void){
        productAPI.updateMonitor(productID: productID, monitor: monitor) { (error: String?) in
            if error == nil {
                self.productStore.updateProductMonitor(productID: productID, monitor: monitor)
            }
            
            completionHandler(error)
        }
    }
}

protocol ProductRequestProtocol {
    func getProduct(regionID: Int, supermarketChainID: Int, productID: Int, completionHandler: @escaping (_ product: ProductModel?, _ error: String?) -> Void)
    
    func getMonitoredProducts(regionID: Int, supermarketChainID: Int, completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void)
    func updateMonitor(productID: Int, monitor: Bool, completionHandler: @escaping (String?) -> Void)
}

protocol ProductStoreProtocol {
    
    func createProductObject(product: ProductModel) -> ProductObject
    
    func getProduct(regionID: Int, supermarketChainID: Int, productID: Int) -> ProductModel?
    func getFavouriteProducts() -> [ProductModel]
    
    func getMonitoredProducts(regionID: Int, supermarketChainID: Int) -> [ProductModel]
    func unmonitorAllProducts()
    
    func createProduct(product: ProductModel)
    func createProducts(products: [ProductModel])
    
    func updateProductFavourite(productID: Int, favourite: Bool)
    func updateProductMonitor(productID: Int, monitor: Bool)
    func clearFavourites()
}
