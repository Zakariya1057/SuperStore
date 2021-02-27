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
    var homeAPI: HomeProtocol
    
    init(homeAPI: HomeProtocol) {
        self.homeAPI = homeAPI
    }
    
    func getHome(completionHandler: @escaping (_ homeModel: HomeModel?, _ error: String?) -> Void){
        homeAPI.getHome(completionHandler: completionHandler)
    }
}

protocol HomeProtocol {
    func getHome(completionHandler: @escaping (_ homeModel: HomeModel?, _ error: String?) -> Void)
}