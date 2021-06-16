//
//  NotificationWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 15/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import UIKit

class NotificationWorker {
    
    private var messageStore: MessageRealmStore =  MessageRealmStore()
    private var dateWorker: DateWorker = DateWorker()
    
    private lazy var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private lazy var rootViewController: UIViewController = ((UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController!)!
    
    func notificationReceived(data: [AnyHashable : Any]){
        let notificationData = getNotificationData(data: data)
        let type: NotificationType = getNotificationType(data: notificationData)
        
        if type == .message {
            let messageData = notificationData["message"] as! [String: AnyObject]
            let message = createMessageModel(message: messageData)
            
            messageStore.saveMessage(message: message)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageNotificationReceived"), object: nil)
        } else if type == .price {
            
        }
        
        updateBadgeNumber()
    }
    
    func notificationPressed(response: UNNotificationResponse){
        
        let content = response.notification.request.content.userInfo
        
        let notificationData: AnyObject = getNotificationData(data: content)
        let type: NotificationType = getNotificationType(data: notificationData)
    
        if type == .message {
            messageNotificationPressed(data: notificationData)
        } else if type == .price {
            priceNotificationPressed(data: notificationData)
        }
        
        updateBadgeNumber()
        
    }
    
    private func messageNotificationPressed(data: AnyObject){
        
        let messageData = data["message"] as! [String: AnyObject]
        let messageType: String = messageData["type"] as! String
        
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController,
           let tabBarController = rootViewController as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            
            let settingMapping: [String: String] = [
                "help": "Help",
                "feature": "Suggest A Feature",
                "feedback": "Feedback",
                "issue": "Report An Issue",
            ]
            
            let settingName: String = settingMapping[messageType]!
            
            let setting: SettingModel =  SettingModel(name: settingName, type: SettingType.init(rawValue: messageType)!)
            
            var pushViewController: Bool = true
            
            // Only if current isn't view controller.
            if let viewController = navController.topViewController as? FeedbackViewController {
                let dataStore = viewController.interactor as! FeedbackDataStore
                
                if dataStore.setting.name == setting.name {
                    pushViewController = false
                }
                
            }
            
            if pushViewController {
                var dataStore = destinationVC.interactor as! FeedbackDataStore
                dataStore.setting = setting
                navController.pushViewController(destinationVC, animated: true)
            }
            
        }
        
    }
    
    private func priceNotificationPressed(data: AnyObject){
        let productID: Int = data["product_id"]! as! Int
        
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowProductViewController") as? ShowProductViewController,
           let tabBarController = rootViewController as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            destinationVC.interactor?.productID = productID
            navController.pushViewController(destinationVC, animated: true)
        }
    }
    
}

extension NotificationWorker {
    
    func getNotificationData(data: [AnyHashable : Any]) -> AnyObject {
        let aps = data["aps"] as! [String: AnyObject]
        return aps["data"]!
    }
    
    func getNotificationType(data: AnyObject) -> NotificationType {
        let type: String = data["type"]! as! String
        return NotificationType.init(rawValue: type)!
    }
    
    func createMessageModel(message: [String: AnyObject]) -> MessageModel {
        let id: Int = message["id"] as! Int
        let text: String = message["text"] as! String
        let type: String = message["type"] as! String
        
        let createdAt: Date = dateWorker.formatDate(date: message["created_at"] as! String)
        let updatedAt: Date = dateWorker.formatDate(date: message["updated_at"] as! String)
        
        return MessageModel(
            id: id,
            type: FeedbackType.init(rawValue: type)!,
            text: text,
            direction: .received,
            status: .success,
            read: false,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension NotificationWorker {
    func updateBadgeNumber(){
        let unreadMessagesCount: Int = messageStore.getUnreadMessagesCount()
        
        UIApplication.shared.applicationIconBadgeNumber = unreadMessagesCount
        setSettingsBadgeNumber(unreadMessagesCount: unreadMessagesCount)
    }
    
    func setSettingsBadgeNumber(unreadMessagesCount: Int){
        if let tabBarController = rootViewController as? UITabBarController {
            if let settingsViewController = tabBarController.viewControllers?[4] {
                settingsViewController.tabBarItem.badgeValue = unreadMessagesCount == 0 ? nil : String(unreadMessagesCount)
            }
        }
    }
}

