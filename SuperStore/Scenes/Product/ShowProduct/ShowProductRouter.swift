//
//  ShowProductRouter.swift
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

@objc protocol ShowProductRoutingLogic
{
    func routeToShowProduct(segue: UIStoryboardSegue?)
    func routeToShowPromotion(segue: UIStoryboardSegue?)
    func routeToShowReviews(segue: UIStoryboardSegue?)
    func routeToShowDescription(segue: UIStoryboardSegue?)
    func routeToEditReview(segue: UIStoryboardSegue?)
    
    func routeToShowIngredients(segue: UIStoryboardSegue?)
    func routeToShowFeatures(segue: UIStoryboardSegue?)
    func routeToShowDimensions(segue: UIStoryboardSegue?)
    
    func routeToShowLists(segue: UIStoryboardSegue?)
    func routeToLogin(segue: UIStoryboardSegue?)
}

protocol ShowProductDataPassing
{
    var dataStore: ShowProductDataStore? { get }
    var selectedProductID: Int? { get set }
}

class ShowProductRouter: NSObject, ShowProductRoutingLogic, ShowProductDataPassing
{
    weak var viewController: ShowProductViewController?
    
    var dataStore: ShowProductDataStore?
    var selectedProductID: Int?
    
    // MARK: Routing
    
    func routeToShowLists(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowListsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowLists(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowListsViewController") as! ShowListsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowLists(source: dataStore!, destination: &destinationDS)
            navigateToShowLists(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToLogin(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! LoginViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToLogin(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToLogin(source: dataStore!, destination: &destinationDS)
            navigateToLogin(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToEditReview(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! EditReviewViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditReview(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "EditReviewViewController") as! EditReviewViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditReview(source: dataStore!, destination: &destinationDS)
            navigateToEditReview(source: viewController!, destination: destinationVC)
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
    
    
    func routeToShowDescription(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowDescriptionViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowDescription(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowDescriptionViewController") as! ShowDescriptionViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowDescription(source: dataStore!, destination: &destinationDS)
            navigateToShowDescription(source: viewController!, destination: destinationVC)
        }
    }
    
    
    func routeToShowIngredients(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowItemsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowIngredients(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowItemsViewController") as! ShowItemsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowIngredients(source: dataStore!, destination: &destinationDS)
            navigateToShowItems(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowFeatures(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowItemsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowIngredients(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowItemsViewController") as! ShowItemsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowFeatures(source: dataStore!, destination: &destinationDS)
            navigateToShowItems(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowDimensions(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowItemsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowIngredients(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowItemsViewController") as! ShowItemsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowDimensions(source: dataStore!, destination: &destinationDS)
            navigateToShowItems(source: viewController!, destination: destinationVC)
        }
    }
    
    
    func routeToShowReviews(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowReviewsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowReviews(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowReviewsViewController") as! ShowReviewsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowReviews(source: dataStore!, destination: &destinationDS)
            navigateToShowReviews(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToLogin(source: ShowProductViewController, destination: LoginViewController)
    {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToShowLists(source: ShowProductViewController, destination: ShowListsViewController)
    {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToEditReview(source: ShowProductViewController, destination: EditReviewViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowReviews(source: ShowProductViewController, destination: ShowReviewsViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowItems(source: ShowProductViewController, destination: ShowItemsViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowDescription(source: ShowProductViewController, destination: ShowDescriptionViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowPromotion(source: ShowProductViewController, destination: ShowPromotionViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowProduct(source: ShowProductViewController, destination: ShowProductViewController)
    {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: - Passing Data
    
    func passDataToLogin(source: ShowProductDataStore, destination: inout LoginDataStore)
    {
    }
    
    func passDataToShowReviews(source: ShowProductDataStore, destination: inout ShowReviewsDataStore)
    {
        destination.productID = source.productID
    }

    func passDataToShowIngredients(source: ShowProductDataStore, destination: inout ShowItemsDataStore)
    {
        destination.title = "Ingredients"
        destination.items = source.product?.ingredients ?? []
    }
    
    func passDataToShowFeatures(source: ShowProductDataStore, destination: inout ShowItemsDataStore)
    {
        destination.title = "Features"
        destination.items = source.product?.features ?? []
    }
    
    func passDataToShowDimensions(source: ShowProductDataStore, destination: inout ShowItemsDataStore)
    {
        destination.title = "Dimensions"
        destination.items = source.product?.dimensions ?? []
    }
    
    func passDataToShowDescription(source: ShowProductDataStore, destination: inout ShowDescriptionDataStore)
    {
        destination.description = source.product?.description ?? ""
    }
    
    func passDataToShowPromotion(source: ShowProductDataStore, destination: inout ShowPromotionDataStore)
    {
        destination.promotionID = source.product!.promotion!.id
    }
    
    func passDataToShowProduct(source: ShowProductDataStore, destination: inout ShowProductDataStore)
    {
        destination.productID = selectedProductID!
    }
    
    func passDataToEditReview(source: ShowProductDataStore, destination: inout EditReviewDataStore)
    {
        destination.product = source.product!
    }
    
    func passDataToShowLists(source: ShowProductDataStore, destination: inout ShowListsDataStore)
    {
        destination.addToList = true
    }
}
