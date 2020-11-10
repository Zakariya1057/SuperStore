//
//  AppDelegate.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 21/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var userSession = UserSession()
    let notificationDelegate = CustomNotificationDelegate()
    
    var navigationController: UINavigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        // Deleting All Realm Data
//        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
//        UIApplication.shared.registerForRemoteNotifications()
        configureNotification(application: application)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Device token: \(token)")
        UserSession.sharedInstance.notificationToken = token
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let application = UIApplication.shared

        print("Notification Arrived")
        
        if(application.applicationState == .active){
          print("user tapped the notification bar when the app is in foreground")
        }

        if(application.applicationState == .inactive){
            print("user tapped the notification bar when the app is in background")
        }
    
        // If notification pressed, take to product page
        // Update product info, price and stuff based on new data.

        completionHandler([.alert, .sound, .badge])
      }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification Pressed")

        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let content = response.notification.request.content.userInfo
        
        if let aps = content["aps"] as? [String: AnyObject] {

            if let productData: AnyObject = aps["data"] {
                let productID: Int = productData["product_id"]! as! Int
                
                print("Navigating To: \(productID)")
                
                // retrieve the root view controller (which is a tab bar controller)
                guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                    return
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                if let conversationVC = storyboard.instantiateViewController(withIdentifier: "productViewController") as? ProductViewController,
                    let tabBarController = rootViewController as? UITabBarController,
                    let navController = tabBarController.selectedViewController as? UINavigationController {
                    conversationVC.product_id = productID
                    navController.pushViewController(conversationVC, animated: true)
                }
                
            }
            
        }
    
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }

    // Enables user permission
    func configureNotification(application: UIApplication) {
           let center = UNUserNotificationCenter.current()
           center.delegate = notificationDelegate
           center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
               guard granted else { return }
               DispatchQueue.main.async {
                    UNUserNotificationCenter.current().delegate = self
                    application.registerForRemoteNotifications()
               }
           }
   }


}
