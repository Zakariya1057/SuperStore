//
//  EditListItemRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol EditListItemRoutingLogic
{
    func routeToShowList(segue: UIStoryboardSegue?)
    func routeToShowPromotion(segue: UIStoryboardSegue?)
}

protocol EditListItemDataPassing
{
    var dataStore: EditListItemDataStore? { get }
}

class EditListItemRouter: NSObject, EditListItemRoutingLogic, EditListItemDataPassing
{
    weak var viewController: EditListItemViewController?
    var dataStore: EditListItemDataStore?
    
    // MARK: Routing
    
    func routeToShowList(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowList(source: dataStore!, destination: &destinationDS)
        } else {
            let navigationViewController = viewController!.navigationController!
            let destinationVC = navigationViewController.viewControllers[navigationViewController.viewControllers.count - 2] as! ShowListViewController
            
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowList(source: dataStore!, destination: &destinationDS)
            callRefreshTableView(source: viewController!, destination: destinationVC)
            navigateToShowList(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowPromotion(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowPromotionViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowPromotion(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowPromotionViewController") as! ShowPromotionViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowPromotion(source: dataStore!, destination: &destinationDS)
            navigateToShowPromotion(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToShowList(source: EditListItemViewController, destination: ShowListViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    func navigateToShowPromotion(source: EditListItemViewController, destination: ShowPromotionViewController)
    {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: Passing data
    
    func passDataToShowList(source: EditListItemDataStore, destination: inout ShowListDataStore)
    {
    }
    
    func passDataToShowPromotion(source: EditListItemDataStore, destination: inout ShowPromotionDataStore)
    {
        destination.promotionID = source.listItem.promotion!.id
    }
    
    // MARK: CallBack Function
    
    func callRefreshTableView(source: EditListItemViewController, destination: ShowListViewController)
    {
        destination.reflectListChanged()
    }
    
}
