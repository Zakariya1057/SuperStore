//
//  HomeRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol HomeRoutingLogic
{
    func routeToShowPromotion(segue: UIStoryboardSegue?)
    func routeToShowProduct(segue: UIStoryboardSegue?)
    func routeToStore(segue: UIStoryboardSegue?)
    func routeToShowList(segue: UIStoryboardSegue?)
    
    func routeToShowStoreResults(segue: UIStoryboardSegue?)
    
    func routeToGrandParentCategories(segue: UIStoryboardSegue?)
    func routeToChildCategories(segue: UIStoryboardSegue?)
}

protocol HomeDataPassing
{
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeToShowList(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowList(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowListViewController") as! ShowListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowList(source: dataStore!, destination: &destinationDS)
            navigateToShowList(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToStore(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! StoreViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToStore(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToStore(source: dataStore!, destination: &destinationDS)
            navigateToStore(source: viewController!, destination: destinationVC)
        }
    }
    
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
    
    func routeToGrandParentCategories(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! GrandParentCategoriesViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToGrandParentCategories(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "GrandParentCategoriesViewController") as! GrandParentCategoriesViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToGrandParentCategories(source: dataStore!, destination: &destinationDS)
            navigateToGrandParentCategories(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToChildCategories(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ChildCategoriesViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToChildCategories(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChildCategoriesViewController") as! ChildCategoriesViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToChildCategories(source: dataStore!, destination: &destinationDS)
            navigateToChildCategories(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowStoreResults(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowStoreResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowStoreResults(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowStoreResultsViewController") as! ShowStoreResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowStoreResults(source: dataStore!, destination: &destinationDS)
            navigateToShowStoreResults(source: viewController!, destination: destinationVC)
        }
    }
    
    //    MARK: Navigation
    
    func navigateToShowList(source: HomeViewController, destination: ShowListViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowProduct(source: HomeViewController, destination: ShowProductViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowPromotion(source: HomeViewController, destination: ShowPromotionViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToStore(source: HomeViewController, destination: StoreViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToGrandParentCategories(source: HomeViewController, destination: GrandParentCategoriesViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToChildCategories(source: HomeViewController, destination: ChildCategoriesViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowStoreResults(source: HomeViewController, destination: ShowStoreResultsViewController)
    {
      source.show(destination, sender: nil)
    }
    //    MARK: Passing data
    
    func passDataToShowList(source: HomeDataStore, destination: inout ShowListDataStore)
    {
        destination.list = source.selectedList
    }
    
    func passDataToShowProduct(source: HomeDataStore, destination: inout ShowProductDataStore)
    {
        destination.productID = source.selectedProductID!
    }
    
    func passDataToShowPromotion(source: HomeDataStore, destination: inout ShowPromotionDataStore)
    {
        destination.promotionID = source.selectedPromotionID!
    }
    
    func passDataToStore(source: HomeDataStore, destination: inout StoreDataStore)
    {
        destination.storeID = source.selectedStoreID!
    }
    
    func passDataToGrandParentCategories(source: HomeDataStore, destination: inout GrandParentCategoriesDataStore)
    {
        destination.storeTypeID = source.storeTypeID
    }
    
    func passDataToChildCategories(source: HomeDataStore, destination: inout ChildCategoriesDataStore)
    {
        if let parentCategoryID = source.viewAllSelectedParentCategoryID, let parentCategoryName = source.viewAllSelectedParentCategoryName {
            destination.parentCategoryID = parentCategoryID
            destination.title = parentCategoryName
        }

        destination.storeTypeID = source.storeTypeID
    }
    
    func passDataToShowStoreResults(source: HomeDataStore, destination: inout ShowStoreResultsDataStore)
    {
        destination.storeTypeID = source.storeTypeID
    }
}
