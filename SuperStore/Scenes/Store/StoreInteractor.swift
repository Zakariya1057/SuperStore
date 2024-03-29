//
//  StoreInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol StoreBusinessLogic
{
    func getStore(request: Store.GetStore.Request)
    var selectedListID: Int? { get set }
}

protocol StoreDataStore
{
    var storeID: Int { get set }
    var selectedListID: Int? { get set }
    var store: StoreModel? { get set }
}

class StoreInteractor: StoreBusinessLogic, StoreDataStore
{
    var presenter: StorePresentationLogic?
    var storeWorker: StoreWorker = StoreWorker(storeAPI: StoreAPI())
    
    var userSession = UserSessionWorker()
    
    var storeID: Int = 1
    var selectedListID: Int?
    var store: StoreModel?
    
    func getStore(request: Store.GetStore.Request)
    {
        storeWorker.getStore(storeID: storeID) { (store: StoreModel?, error: String?) in

            var response = Store.GetStore.Response(store: store, error: error)
            
            if error == nil {
                self.store = store
            } else {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentStore(response: response)
        }
    }
}
