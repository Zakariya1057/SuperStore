//
//  AdvancedSettingsPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/06/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AdvancedSettingsPresentationLogic
{
    func presentSettings(response: AdvancedSettings.GetSettings.Response)
    func presentSearchCache(response: AdvancedSettings.ClearSearchCache.Response)
    func presentUpdateNotifications(response: AdvancedSettings.UpdateNotifications.Response)
    func presentDeleted(response: AdvancedSettings.Delete.Response)
}

class AdvancedSettingsPresenter: AdvancedSettingsPresentationLogic
{
    
    weak var viewController: AdvancedSettingsDisplayLogic?
    
    func presentSettings(response: AdvancedSettings.GetSettings.Response)
    {
        
        let viewModel = AdvancedSettings.GetSettings.ViewModel(
            parentSetting: response.parentSetting,
            displaySections: getDisplaySections(response: response)
        )
        
        viewController?.displaySettings(viewModel: viewModel)
    }
    
    func presentDeleted(response: AdvancedSettings.Delete.Response) {
        let viewModel = AdvancedSettings.Delete.ViewModel(error: response.error)
        viewController?.displayedDeleted(viewModel: viewModel)
    }
    
    
    func presentUpdateNotifications(response: AdvancedSettings.UpdateNotifications.Response) {
        let viewModel = AdvancedSettings.UpdateNotifications.ViewModel(error: response.error)
        viewController?.displayUpdateNotifications(viewModel: viewModel)
    }
    
    func presentSearchCache(response: AdvancedSettings.ClearSearchCache.Response) {
        let viewModel = AdvancedSettings.ClearSearchCache.ViewModel(error: response.error)
        viewController?.displayClearSearchCache(viewModel: viewModel)
    }
}

extension AdvancedSettingsPresenter {
    func getDisplaySections(response: AdvancedSettings.GetSettings.Response) -> [AdvancedSettings.DisplaySection] {
        var displaySections: [AdvancedSettings.DisplaySection] = []

        let setting: SettingModel = response.parentSetting
        
        switch setting.type {
        
        case .helpAndFeedback:
            displaySections = helpAndFeedbackSections(response: response)
        
        case .userManagement:
            displaySections = userSettingSections(user: response.user!)
        
        case .deviceStorage:
            displaySections = deviceStorageSections()
            
//        case .regionAndSupermarketChain:
//            displaySections = regionAndSupermarketSections(
//                regionName: response.regionName,
//                supermarketChainName: response.supermarketChainName
//            )
            
        default:
            print("Unknown Setting Type: \( type(of: setting.type) )")

        }
        
        return displaySections
    }

}

extension AdvancedSettingsPresenter {
    
    func helpAndFeedbackSections(response: AdvancedSettings.GetSettings.Response) -> [AdvancedSettings.DisplaySection] {
        var displaySections: [AdvancedSettings.DisplaySection] = []
        
        let unreadHelpMessages: Int = response.unreadHelpMessages
        let unreadFeaturepMessages: Int = response.unreadFeaturepMessages
        let unreadFeedbackMessages: Int = response.unreadFeedbackMessages
        let unreadIssueMessages: Int = response.unreadIssueMessages

        if response.loggedIn {
            displaySections.append(AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Help", type: .help, badgeNumber: unreadHelpMessages)
            ]))
        }
        
        displaySections.append(contentsOf: [
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Suggest A Feature", type: .feature, badgeNumber: unreadFeaturepMessages),
                SettingModel(name: "Feedback", type: .feedback, badgeNumber: unreadFeedbackMessages)
            ]),
            
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Report An Issue", type: .issue, badgeNumber: unreadIssueMessages),
            ])
            
        ])
        
        return displaySections
    }
    
    func userSettingSections(user: UserModel) -> [AdvancedSettings.DisplaySection] {
        return [
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Name", value: user.name, type: .name),
                SettingModel(name: "Email", value: user.email, type: .email)
            ]),
            
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Password", value: "••••••••••••••", type: .password)
            ]),
            
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Notifications", on: user.sendNotifications, type: .notification)
            ]),
            
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Delete Account", type: .delete)
            ])
            
        ]
    }
    
    func deviceStorageSections() -> [AdvancedSettings.DisplaySection] {
        return [
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Clear Cached Images", type: .imageCache)
            ]),
            
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Clear Cached Suggestions", type: .searchCache)
            ])
        ]
    }
    
    func regionAndSupermarketSections(regionName: String, supermarketChainName: String) -> [AdvancedSettings.DisplaySection] {
        return [
            AdvancedSettings.DisplaySection(settings: [
                SettingModel(name: "Province", value: regionName, type: .region),
                SettingModel(name: "Store", value: supermarketChainName, type: .store),
            ])
        ]
    }
}
