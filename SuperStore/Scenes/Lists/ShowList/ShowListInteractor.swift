//
//  ShowListInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowListBusinessLogic
{
    func getList(request: ShowList.GetList.Request)
    func updateListItem(request: ShowList.UpdateListItem.Request)
    func deleteListItem(request: ShowList.DeleteListItem.Request)
    func updateListTotal(request: ShowList.UpdateListTotal.Request)
    
    var list: ListModel! { get set }
}

protocol ShowListDataStore
{
    var list: ListModel! { get set }
}

class ShowListInteractor: ShowListBusinessLogic, ShowListDataStore
{
    var presenter: ShowListPresentationLogic?
    
    var listWorker: ListWorker = ListWorker(listAPI: ListAPI())
    var listItemWorker: ListItemWorker = ListItemWorker(listItemAPI: ListItemAPI())
    var listPriceWorker: ListPriceWorker = ListPriceWorker()
    var userSession = UserSessionWorker()
    
    var list: ListModel!
    
    func getList(request: ShowList.GetList.Request)
    {
        listWorker.getList(listID: list.id) { (list: ListModel?, error: String?) in
            
            var response = ShowList.GetList.Response(list: list, error: error)
            
            if list != nil {
                self.list = list
            }
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
           
            self.presenter?.presentList(response: response)
        }
    }
    
    func updateListItem(request: ShowList.UpdateListItem.Request){
        let listID: Int = list.id
        let productID: Int = request.productID
        let quantity: Int = request.quantity
        let tickedOff = request.tickedOff

        listItemWorker.updateItem(listID: listID, productID: productID, quantity: quantity, tickedOff: tickedOff) { (error: String?) in
            var response = ShowList.UpdateListItem.Response(error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentListUpdated(response: response)
        }
        
        for (categoryIndex, category) in list.categories.enumerated() {
            for (itemIndex,item) in category.items.enumerated() {
                if item.productID == productID {
                    list.categories[categoryIndex].items[itemIndex].tickedOff = tickedOff
                }
            }
        }
    }
    
    func deleteListItem(request: ShowList.DeleteListItem.Request){
        let listID: Int = list.id
        let productID: Int = request.productID
        
        listItemWorker.deleteItem(listID: listID, productID: productID) { (error: String?) in
            var response = ShowList.DeleteListItem.Response(error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentListDeleted(response: response)
        }
    }
    
    func updateListTotal(request: ShowList.UpdateListTotal.Request){
        let (totalPrice, oldTotalPrice) = self.calculateTotalListPrice()

        listWorker.updateListTotalPrice(listID: list.id)
        
        list.totalPrice = totalPrice
        list.oldTotalPrice = oldTotalPrice
        
        let response = ShowList.UpdateListTotal.Response(list: list)
        self.presenter?.presentListUpdateTotal(response: response)
    }
}

extension ShowListInteractor {
    private func calculateTotalListPrice() -> (Double, Double?){
        var items: [ListItemModel] = []
        
        for category in list.categories {
            items.append(contentsOf: category.items)
        }
        
        return listPriceWorker.calculateListPrice(items: items)
    }
}
