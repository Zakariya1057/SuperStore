//
//  ProductWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductWorker {
    var productAPI: ProductRequestProtocol
    var productStore: ProductStoreProtocol
    
    init(productAPI: ProductRequestProtocol) {
        self.productAPI = productAPI
        self.productStore = ProductRealmStore()
    }
    
    func getProduct(productID: Int, completionHandler: @escaping (_ product: ProductModel?, _ error: String?) -> Void){
        
        if let product = productStore.getProduct(productID: productID){
            completionHandler(product, nil)
        }
        
        productAPI.getProduct(productID: productID) { (product: ProductModel?, error: String?) in
            if let product = product {
                // Remove expired promotion
                // Remove expired sale
                self.productStore.createProduct(product: product)
            }
            
            completionHandler(product, error)
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
    func getProduct(productID: Int, completionHandler: @escaping (_ product: ProductModel?, _ error: String?) -> Void)
    func updateMonitor(productID: Int, monitor: Bool, completionHandler: @escaping (String?) -> Void)
}

protocol ProductStoreProtocol {
    
    func createProductObject(product: ProductModel) -> ProductObject
    
    func getProduct(productID: Int) -> ProductModel?
    func getFavouriteProducts() -> [ProductModel]
    
    func createProduct(product: ProductModel)
    func createProducts(products: [ProductModel])
    
    func updateProductFavourite(productID: Int, favourite: Bool)
    func updateProductMonitor(productID: Int, monitor: Bool)
    func clearFavourites()
}
