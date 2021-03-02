//
//  ShowProductResultsRouter.swift
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

@objc protocol ShowProductResultsRoutingLogic
{
  func routeToShowProduct(segue: UIStoryboardSegue?)
}

protocol ShowProductResultsDataPassing
{
  var dataStore: ShowProductResultsDataStore? { get }
}

class ShowProductResultsRouter: NSObject, ShowProductResultsRoutingLogic, ShowProductResultsDataPassing
{
  weak var viewController: ShowProductResultsViewController?
  var dataStore: ShowProductResultsDataStore?
  
  // MARK: Routing
  
    func routeToShowProduct(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowProductViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProduct(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowProductViewController") as! ShowProductViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProduct(source: dataStore!, destination: &destinationDS)
            navigateToShowProduct(source: viewController!, destination: destinationVC)
        }
    }
    
    //    MARK: Navigation
    
    func navigateToShowProduct(source: ShowProductResultsViewController, destination: ShowProductViewController)
    {
        source.show(destination, sender: nil)
    }
    
    //    MARK: Passing data
    
    func passDataToShowProduct(source: ShowProductResultsDataStore, destination: inout ShowProductDataStore)
    {
        destination.productID = viewController!.selectedProductID!
    }
}
