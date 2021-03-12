//
//  HomeWorker.swift
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

class HomeWorker
{
    var homeAPI: HomeRequestProtocol
    var homeStore: HomeStoreProtocol
    
    init(homeAPI: HomeRequestProtocol) {
        self.homeAPI = homeAPI
        self.homeStore = HomeRealmStore()
    }
    
    func getHome(storeTypeID: Int, completionHandler: @escaping (_ home: HomeModel?, _ error: String?) -> Void){
        
//        if let home = homeStore.getHome() {
//            completionHandler(home, nil)
//        }
        
        homeAPI.getHome { (home: HomeModel?, error: String?) in
            if let home = home {
                self.homeStore.createHome(storeTypeID: storeTypeID, home: home)
            }
            
            completionHandler(home, error)
        }
    }
}

protocol HomeRequestProtocol {
    func getHome(completionHandler: @escaping (_ home: HomeModel?, _ error: String?) -> Void)
}

protocol HomeStoreProtocol {
    func createHome(storeTypeID: Int, home: HomeModel)
    func getHome() -> HomeModel?
}
