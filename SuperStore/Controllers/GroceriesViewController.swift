//
//  GroceryViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Tabman
import Pageboy

class GroceriesViewController: TabmanViewController,GroceryDelegate {

    var listDelegate: NewProductDelegate?
    
    let headers:[String] = ["Fruits","Bakery","Potatoes","Meat & Poultry"]
    let viewcontrollers:[GroceryTableViewController] = [GroceryTableViewController(),GroceryTableViewController(),GroceryTableViewController(),GroceryTableViewController()]
    
    // Create bar
    let bar = TMBar.ButtonBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 4.0, right: 16.0)
        bar.layout.interButtonSpacing = 24.0
        bar.indicator.weight = .light
        bar.indicator.cornerStyle = .eliptical
        bar.fadesContentEdges = true
        bar.spacing = 16.0

        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
    }
}

extension GroceriesViewController {
    
    func showGroceryItem(){
        self.performSegue(withIdentifier: K.Paths.showGroceryItem, sender: self)
    }
    
    func addToList(_ product: ProductModel){
        
        if listDelegate != nil {
            listDelegate?.productAdded(product: product)
        } else {
            
        }
        print("Adding To List")
    }
}

extension GroceriesViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: headers[index])
//        item.badgeValue = "New"
        return item
    }
    

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return headers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        let viewController = viewcontrollers[index]
        viewController.delegate = self
        return viewController
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
