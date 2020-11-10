//
//  CustomNotificationDelegate.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/11/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import UserNotifications
 
class CustomNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Notification Delegate")
           completionHandler([.alert, .sound, .badge])
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           defer { completionHandler() }
           guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
           // perform action here
        print("Notification Delegate")
           
       }
}
