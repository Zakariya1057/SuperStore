//
//  SettingsInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SettingsBusinessLogic
{
    func getSettings(request: Settings.GetUserDetails.Request)
    func getUserStore(request: Settings.GetStore.Request)
    func updateNotification(request: Settings.UpdateNotifications.Request)
    
    func logout(request: Settings.Logout.Request)
    func delete(request: Settings.Delete.Request)
}

protocol SettingsDataStore
{
    var user: UserModel? { get set }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore
{
    var presenter: SettingsPresentationLogic?
    
    var userWorker: UserSettingsWorker = UserSettingsWorker(userStore: UserRealmStore())
    var userSession: UserSessionWorker = UserSessionWorker()
    
    var supermarketChainWorker: SupermarketChainWorker = SupermarketChainWorker()
    var regionWorker: RegionWorker = RegionWorker()
    var messageWorker: MessageWorker = MessageWorker(messageAPI: MessageAPI())
    
    var user: UserModel?
    
    func getSettings(request: Settings.GetUserDetails.Request)
    {
        userWorker.getUser { (user: UserModel?) in
            self.user = user
            
            let supermarketChainName: String = self.supermarketChainWorker.getSupermarketChainName(supermarketChainID: user!.supermarketChainID)
            let regionName: String = self.regionWorker.getRegionName(regionID: user!.regionID)
            let unreadMessagesCount: Int = self.messageWorker.getUnreadMessagesCount()
            
            let response = Settings.GetUserDetails.Response(
                user: self.user,
                
                unreadMessagesCount: unreadMessagesCount,
                
                supermarketChainName: supermarketChainName,
                regionName: regionName
            )
            
            self.presenter?.presentUserDetails(response: response)
        }
    }
    
    func getUserStore(request: Settings.GetStore.Request) {
        let supermarketChainID: Int = userSession.getSupermarketChainID()
        let storeName = supermarketChainWorker.getSupermarketChainName(supermarketChainID: supermarketChainID)
        
        let response = Settings.GetStore.Response(storeName: storeName)
        self.presenter?.presentUserStore(response: response)
    }
    
    func updateNotification(request: Settings.UpdateNotifications.Request){
        let sendNotification: Bool = request.sendNotifications
        let notificationToken: String? = userSession.getUserNotificationToken()
        
        userWorker.updateNotifications(sendNotifications: sendNotification, notificationToken: notificationToken) { (error: String?) in
            let response = Settings.UpdateNotifications.Response(error: error)
            self.presenter?.presentUpdateNotifications(response: response)
        }
    }
    
    func logout(request: Settings.Logout.Request){
        userWorker.logout { (error: String?) in
            let response = Settings.Logout.Response(error: error)
            self.presenter?.presentLogout(response: response)
        }
    }
    
    func delete(request: Settings.Delete.Request) {
        userWorker.deleteUser { (error: String?) in
            let response = Settings.Delete.Response(error: error)
            self.presenter?.presentDeleted(response: response)
        }
        
    }
}
