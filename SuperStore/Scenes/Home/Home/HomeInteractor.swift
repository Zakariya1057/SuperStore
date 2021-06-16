//
//  HomeInteractor.swift
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

protocol HomeBusinessLogic
{
    func getHome(request: Home.GetHome.Request)
    func updateLocation(request: Home.UpdateLocation.Request)
    
    var selectedList: ListModel? { get set }
    var selectedProductID: Int? { get set }
    var selectedPromotionID: Int? { get set }
    var selectedStoreID: Int? { get set }
    
    var storeTypeID: Int { get }
    
    func setViewAllSelectedCategory(parentCategoryID: Int, parentCategoryName: String)
}

protocol HomeDataStore
{
    var selectedList: ListModel? { get set }
    var selectedProductID: Int? { get set }
    var selectedPromotionID: Int? { get set }
    var selectedStoreID: Int? { get set }
    
    var regionID: Int { get }
    var storeTypeID: Int { get }
    
    var viewAllSelectedParentCategoryName: String? { get set }
    var viewAllSelectedParentCategoryID: Int? { get set }
    
    var closestStoreID: Int { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
    var presenter: HomePresentationLogic?
    
    var homeWorker: HomeWorker? = HomeWorker(homeAPI: HomeAPI())
    var locationWorker: LocationWorker = LocationWorker(locationAPI: LocationAPI())
    
    var userSession: UserSessionWorker = UserSessionWorker()
    
    var selectedList: ListModel?
    var selectedProductID: Int?
    var selectedPromotionID: Int?
    var selectedStoreID: Int?
    
    var viewAllSelectedParentCategoryName: String? = nil
    var viewAllSelectedParentCategoryID: Int? = nil
    
    var closestStoreID: Int = 1
    
    var regionID: Int {
        return userSession.getRegion()
    }
    
    var storeTypeID: Int {
        return userSession.getStore()
    }
    
    func getHome(request: Home.GetHome.Request)
    {
        let latitude: Double? = request.latitude
        let longitude: Double? = request.longitude
        
        homeWorker?.getHome(
            regionID: regionID,
            storeTypeID: storeTypeID,
            latitude: latitude,
            longitude: longitude,
            completionHandler: { (home: HomeModel?, error: String?) in
                
                var response = Home.GetHome.Response(home: home, error: error)
                
                if error != nil {
                    response.offline = !self.userSession.isOnline()
                } else {
                    if let home = home, home.longitude != nil {
                        if let store = home.stores.first {
                            self.closestStoreID = store.id
                        }
                    }
                }
                
                self.presenter?.presentHome(response: response)
                
            })
    }
    
    func updateLocation(request: Home.UpdateLocation.Request){
        let latitude: Double = request.latitude
        let longitude: Double = request.longitude
        let loggedIn: Bool = userSession.isLoggedIn()
        
        locationWorker.updateLocation(loggedIn: loggedIn, latitude: latitude, longitude: longitude) { (error: String?) in
            //            print(error)
        }
    }
}

extension HomeInteractor {
    func setViewAllSelectedCategory(parentCategoryID: Int, parentCategoryName: String){
        self.viewAllSelectedParentCategoryID = parentCategoryID
        self.viewAllSelectedParentCategoryName = parentCategoryName
    }
}
