//
//  GroceryGroupViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ChildCategoriesViewController: TabmanViewController,GroceryDelegate, GroceriesProductsDelegate {

    var listDelegate: NewProductDelegate?
    
    var groceryHandler = GroceryProductsHandler()
    
    var parent_category_id: Int?
    
    var headers:[String] = []
    var viewcontrollers:[GroceryTableViewController] = []
    
    var header_text:String?
    
    var categories: [GroceryProductsModel] = []
    
    var selected_product_id:Int?
    
    // Create bar
    let bar = TMBar.ButtonBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groceryHandler.delegate = self
        groceryHandler.request(parent_category_id: parent_category_id!)
        
        self.dataSource = self
        configureUI()
    }
    
    func configureUI(){
        
        self.title = header_text
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 4.0, right: 16.0)
        bar.layout.interButtonSpacing = 24.0
        bar.indicator.weight = .light
        bar.indicator.cornerStyle = .eliptical
        bar.fadesContentEdges = true
        bar.spacing = 16.0

        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    func contentLoaded(categories: [GroceryProductsModel]) {
        self.categories = categories
        
        for category in categories {
            headers.append(category.name)
            viewcontrollers.append(GroceryTableViewController())
        }
        
        self.reloadData()
    }
    
}

extension ChildCategoriesViewController {
    
    func showGroceryItem(_ product_id: Int){
        self.selected_product_id = product_id
        self.performSegue(withIdentifier: K.Paths.showGroceryItem, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProductViewController
        destinationVC.product_id = selected_product_id!
    }
    
    func addToList(_ product: ProductModel){
        
        if listDelegate != nil {
            listDelegate?.productAdded(product: product)
        } else {
            
        }
        print("Adding To List")
    }
}

extension ChildCategoriesViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: headers[index])
//        item.badgeValue = "New"
        return item
    }
    

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return headers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let viewController = viewcontrollers[index]
        viewController.products = categories[index].products
        viewController.delegate = self
        return viewController
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
