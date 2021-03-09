//
//  ShowRefineRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ShowRefineRoutingLogic
{
    func routeToShowProductResults(segue: UIStoryboardSegue?)
}

protocol ShowRefineDataPassing
{
    var dataStore: ShowRefineDataStore? { get }
}

class ShowRefineRouter: NSObject, ShowRefineRoutingLogic, ShowRefineDataPassing
{
    weak var viewController: ShowRefineViewController?
    var dataStore: ShowRefineDataStore?
    
    // MARK: Routing
    
    func routeToShowProductResults(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let navigationViewController = segue.destination as! UINavigationController
            let destinationVC = navigationViewController.topViewController as! ShowProductResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProductResults(source: dataStore!, destination: &destinationDS)
            callRefineOnShowProductResults(source: viewController!, destination: destinationVC)
        } else {
            
            //    let navigationViewController = viewController!.presentingViewController as! UINavigationController
            //    let destinationVC = navigationViewController.topViewController as! ShowProductResultsViewController
            
            let tabViewController = viewController!.presentingViewController as! UITabBarController
            let tabIndex: Int = tabViewController.selectedIndex
            
            let navigationViewController = tabViewController.viewControllers![tabIndex] as! UINavigationController
            
            let destinationVC = navigationViewController.viewControllers.last as! ShowProductResultsViewController
            
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProductResults(source: dataStore!, destination: &destinationDS)
            navigateToShowProductResults(source: viewController!, destination: destinationVC)
            callRefineOnShowProductResults(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToShowProductResults(source: ShowRefineViewController, destination: ShowProductResultsViewController)
    {
        source.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    func passDataToShowProductResults(source: ShowRefineDataStore, destination: inout ShowProductResultsDataStore)
    {
        destination.selectedRefineOptions = source.selectedRefineOptions
    }
    
    // MARK: CallBack Function
    
    func callRefineOnShowProductResults(source: ShowRefineViewController, destination: ShowProductResultsViewController)
    {
        destination.refineResults()
    }
}
