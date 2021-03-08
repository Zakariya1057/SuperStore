//
//  UserLoggedInRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

@objc protocol UserLoggedInRoutingLogic
{
    func routeToLoggedIn(segue: UIStoryboardSegue?)
}

class UserLoggedInRouter: NSObject, UserLoggedInRoutingLogic
{
    weak var viewController: UIViewController?
    
    func routeToLoggedIn(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let navigationViewController = segue.destination as! UINavigationController
            let destinationVC = navigationViewController.topViewController as! SettingsViewController
            callUserLoggedIn(source: viewController!, destination: destinationVC)
        } else {

            var parentController: UIViewController = viewController!
            var tabViewController: UITabBarController?
            
            while(true) {
                if parentController is UITabBarController {
                    tabViewController = (parentController as! UITabBarController)
                    break
                } else {
                    parentController = parentController.presentingViewController!
                }
            }

            let tabIndex: Int = tabViewController!.selectedIndex
            
            let navigationViewController = tabViewController!.viewControllers![tabIndex] as! UINavigationController
            
            let destinationVC = navigationViewController.viewControllers.last!
            
            navigateToParent(source: viewController!, destination: destinationVC)
            callUserLoggedIn(source: viewController!, destination: destinationVC as! UserLoggedInProtocol)
        }
    }
    
   
    //MARK: - Navigation
    func navigateToParent(source: UIViewController, destination: UIViewController)
    {
        source.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - User Logged In Callback
    func callUserLoggedIn(source: UIViewController, destination: UserLoggedInProtocol)
    {
        destination.userLoggedInSuccessfully()
    }
}
