//
//  SettingsPresenter.swift
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

protocol SettingsPresentationLogic
{
    func presentUserDetails(response: Settings.GetUserDetails.Response)
    func presentUserStore(response: Settings.GetStore.Response)
    func presentUpdateNotifications(response: Settings.UpdateNotifications.Response)
    func presentLogout(response: Settings.Logout.Response)
    func presentDeleted(response: Settings.Delete.Response)
}

class SettingsPresenter: SettingsPresentationLogic
{
    weak var viewController: SettingsDisplayLogic?
    
    func presentUserDetails(response: Settings.GetUserDetails.Response)
    {
        var displayUserSections: [Settings.DisplayUserSection] = []
        
        var loggedIn: Bool = false
        
        if let user = response.user {
            
            let storeTypeName: String = response.storeTypeName
            let regionName: String = response.regionName
            
            if user.token != "" {
                
                loggedIn = true
                
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Name", value: user.name, type: .name),
                        Settings.DisplayUserField(name: "Email", value: user.email, type: .email),
                        Settings.DisplayUserField(name: "Password", value: "••••••••••••••", type: .password),
                        Settings.DisplayUserField(name: "Notifications", on: user.sendNotifications, type: .notification),
                    ])
                )
                
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Province", value: regionName, type: .store),
                        Settings.DisplayUserField(name: "Store", value: storeTypeName, type: .store),
                    ])
                )
                
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Feedback", type: .feedback),
                        Settings.DisplayUserField(name: "Report Issues", type: .reportIssue),
                        Settings.DisplayUserField(name: "Delete Account", type: .delete)
                    ])
                )
                
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Logout", type: .logout)
                    ])
                )
            } else {
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Province", value: regionName, type: .store),
                        Settings.DisplayUserField(name: "Store", value: storeTypeName, type: .store),
                    ])
                )
                
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Login", type: .login)
                    ])
                )
                
                displayUserSections.append(
                    Settings.DisplayUserSection(fields: [
                        Settings.DisplayUserField(name: "Feedback", type: .feedback),
                        Settings.DisplayUserField(name: "Report Issues", type: .reportIssue)
                    ])
                )
            }
        }
        
        let viewModel = Settings.GetUserDetails.ViewModel(displayUserSections: displayUserSections, loggedIn: loggedIn)
        
        viewController?.displayUserDetails(viewModel: viewModel)
    }
    
    func presentUserStore(response: Settings.GetStore.Response) {
        let viewModel = Settings.GetStore.ViewModel(storeName: response.storeName)
        viewController?.displayUserStore(viewModel: viewModel)
    }
    
    func presentUpdateNotifications(response: Settings.UpdateNotifications.Response) {
        let viewModel = Settings.UpdateNotifications.ViewModel(error: response.error)
        viewController?.displayUpdateNotifications(viewModel: viewModel)
    }
    
    func presentLogout(response: Settings.Logout.Response) {
        let viewModel = Settings.Logout.ViewModel(error: response.error)
        viewController?.displayedLogout(viewModel: viewModel)
    }
    
    func presentDeleted(response: Settings.Delete.Response) {
        let viewModel = Settings.Delete.ViewModel(error: response.error)
        viewController?.displayedDeleted(viewModel: viewModel)
    }
}
