//
//  BackToListRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class BackToShowListRouter: NSObject {
    
    weak var viewController: UIViewController?
    
    @objc func routeToShowList(segue: UIStoryboardSegue?)
    {
        if segue == nil {
            let parentViewControllers = viewController!.navigationController?.viewControllers ?? []
            var destinationVC: ShowListViewController?
            
            for parentViewController in parentViewControllers{
                if parentViewController is ShowListViewController {
                    destinationVC = parentViewController as? ShowListViewController
                }
            }
            
            if let destinationVC = destinationVC {
                navigateToShowList(source: viewController!, destination: destinationVC)
            } else {
                navigateBack(source: viewController!, destination: viewController!)
            }
           
        }
    }
    
    //  MARK: Navigation
    
    func navigateToShowList(source: UIViewController, destination: ShowListViewController)
    {
        source.navigationController!.popToViewController(destination, animated: true)
    }
    
    func navigateBack(source: UIViewController, destination: UIViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }

}
                                
                
