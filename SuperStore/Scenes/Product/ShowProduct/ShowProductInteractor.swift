//
//  ShowProductInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowProductBusinessLogic
{
    func getProduct(request: ShowProduct.GetProduct.Request)
    func updateFavourite(request: ShowProduct.UpdateFavourite.Request)
    func updateMonitoring(request: ShowProduct.UpdateMonitoring.Request)
    
    func getListItem(request: ShowProduct.GetListItem.Request)
    func createListItem(request: ShowProduct.CreateListItem.Request)
    func updateListItem(request: ShowProduct.UpdateListItem.Request)
    
    var productID: Int { get set }
    var selectedListID: Int? { get set }
    var listSelectedFromProduct: Bool { get set }
}

protocol ShowProductDataStore
{
    var productID: Int { get set }
    var product: ProductModel? { get set }
    
    var selectedListID: Int? { get set }
    var listSelectedFromProduct: Bool { get set }
}

class ShowProductInteractor: ShowProductBusinessLogic, ShowProductDataStore
{
    var presenter: ShowProductPresentationLogic?
    var productWorker: ProductWorker = ProductWorker(productAPI: ProductAPI())
    var favouriteWorker: FavouriteWorker = FavouriteWorker(favouriteAPI: FavouriteAPI())
    
    var userSession = UserSessionWorker()
    
    var listItemWorker: ListItemWorker = ListItemWorker(listItemAPI: ListItemAPI())
    
    var selectedListID: Int?
    var listSelectedFromProduct: Bool = false
    
    var regionID: Int {
        return userSession.getRegion()
    }
    
    var productID: Int = 1
    var product: ProductModel?
    
    func getProduct(request: ShowProduct.GetProduct.Request)
    {
        productWorker.getProduct(regionID: regionID, productID: productID) { (product: ProductModel?, error: String?) in
            
            var response = ShowProduct.GetProduct.Response(product: product, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            } else {
                self.product = product
            }
            
            self.presenter?.presentProduct(response: response)
        }
    }
    
    func updateFavourite(request: ShowProduct.UpdateFavourite.Request){
        favouriteWorker.updateFavourite(productID: product!.id, favourite: request.favourite) { (error: String?) in
            let response = ShowProduct.UpdateFavourite.Response(error: error)
            self.presenter?.presentFavourite(response: response)
        }
    }
    
    func updateMonitoring(request: ShowProduct.UpdateMonitoring.Request){
        productWorker.updateMonitor(productID: product!.id, monitor: request.monitor) { (error: String?) in
            let response = ShowProduct.UpdateMonitoring.Response(error: error)
            self.presenter?.presentMonitoring(response: response)
        }
    }
}

extension ShowProductInteractor {
    func getListItem(request: ShowProduct.GetListItem.Request){
        listItemWorker.getListItem(listID: request.listID, productID: request.productID) { (listItem: ListItemModel?) in
            let response = ShowProduct.GetListItem.Response(listItem: listItem)
            self.presenter?.presentListItem(response: response)
        }
    }
    
    func createListItem(request: ShowProduct.CreateListItem.Request){
        listItemWorker.createItem(listID: request.listID, product: product!) { (listItem: ListItemModel?, error: String?) in
            var response = ShowProduct.CreateListItem.Response(listItem: listItem, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentListItemCreated(response: response)
        }
    }
    
    func updateListItem(request: ShowProduct.UpdateListItem.Request){
        listItemWorker.updateItem(listID: request.listID, productID: request.productID, quantity: request.quantity, tickedOff: false) { (error: String?) in
            var response = ShowProduct.UpdateListItem.Response(error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentListItemUpdated(response: response)
        }
    }
}
