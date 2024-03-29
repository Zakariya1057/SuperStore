//
//  MonitoredProductsInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MonitoredProductsBusinessLogic
{
    func getMonitoredProducts(request: MonitoredProducts.GetMonitoredProducts.Request)
    func deleteMonitoredProduct(request: MonitoredProducts.DeleteMonitoredProduct.Request)

    func setSelectedProduct(productID: Int)
}

protocol MonitoredProductsDataStore
{
    var regionID: Int { get set }
    var supermarketChainID: Int { get set }
    var selectedProductID: Int? { get set }
}

class MonitoredProductsInteractor: MonitoredProductsBusinessLogic, MonitoredProductsDataStore
{
    
    var presenter: MonitoredProductsPresentationLogic?
    var productWorker: ProductWorker = ProductWorker(productAPI: ProductAPI())
    
    var supermarketChainID: Int = 2
    var regionID: Int = 1
    
    var selectedProductID: Int? = nil
    
    var userSession: UserSessionWorker = UserSessionWorker()
    
    func getMonitoredProducts(request: MonitoredProducts.GetMonitoredProducts.Request)
    {
        productWorker.getMonitoredProducts(regionID: regionID, supermarketChainID: supermarketChainID, completionHandler: { (products: [ProductModel], error: String?) in
            var response = MonitoredProducts.GetMonitoredProducts.Response(products: products, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentMonitoredProducts(response: response)
        })
    }
    
    func deleteMonitoredProduct(request: MonitoredProducts.DeleteMonitoredProduct.Request){
        let productID: Int = request.productID
        
        productWorker.updateMonitor(productID: productID, monitor: false) { (error: String?) in
            let response = MonitoredProducts.DeleteMonitoredProduct.Response(error: error)
            self.presenter?.presentDeletedMonitoredProduct(response: response)
        }
    }
}

extension MonitoredProductsInteractor {
    func setSelectedProduct(productID: Int){
        selectedProductID = productID
    }
}
