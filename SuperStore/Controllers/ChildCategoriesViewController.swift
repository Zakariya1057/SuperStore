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

protocol ListSelectedDelegate {
    func list_selected(list_id: Int)
}

class ChildCategoriesViewController: TabmanViewController,GroceryDelegate, GroceriesProductsDelegate, ListSelectedDelegate {

    var list_delegate: NewProductDelegate?
    
    var groceryHandler = GroceryProductsHandler()
    
    var parent_category_id: Int?
    var parent_category_name: String? // Set this in parent and pass to child
    
    var headers:[String] = []
    var viewcontrollers:[GroceryTableViewController] = []
    
    var header_text:String?
    
    var categories: [GroceryProductsModel] = []
    
    var selected_product_id:Int?
    
    // Create bar
    let bar = TMBar.ButtonBar()
    
    var listHandler = ListItemsHandler()
    
    var add_to_list_product_index: Int?
    
    var selected_list_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groceryHandler.delegate = self
        groceryHandler.request(parent_category_id: parent_category_id!)
        
        if(delegate == nil){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.dataSource = self
        configureUI()
    }
    
    func configureUI(){
        
        self.title = header_text
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 6.0, right: 16.0)
        bar.layout.interButtonSpacing = 30.0
        
        bar.layout.showSeparators = true
        bar.layout.separatorColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        bar.layout.separatorWidth = 0.5
        
        
        bar.indicator.weight = .medium
        bar.indicator.cornerStyle = .square
        bar.fadesContentEdges = true
        bar.spacing = 30.0

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
    
    func show_grocery_item(_ product_id: Int){
        self.selected_product_id = product_id
        self.performSegue(withIdentifier: K.Paths.showGroceryItem, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProductViewController
        destinationVC.product_id = selected_product_id!
    }
    
    func add_to_list(_ product: ProductModel){
        
        if list_delegate != nil {
            list_delegate?.productAdded(product: product,parent_category_id: parent_category_id!,parent_category_name: parent_category_name!)
        } else {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            
            vc.delegate = self
            
            self.present(vc, animated: true)
            
            self.add_to_list_product_index = product.id
        }
        
        print("Adding To List")
    }
    
    func list_selected(list_id: Int) {
        self.selected_list_id = list_id
        listHandler.create(list_id: list_id, list_data: ["product_id": String(add_to_list_product_index!)])
    }
    
    func remove_from_list(_ product: ProductModel) {
        list_delegate!.productRemoved(product: product, parent_category_id: parent_category_id!)
    }
    
    func update_quantity(_ product: ProductModel) {

        if list_delegate != nil {
             list_delegate!.productQuantityChanged(product: product, parent_category_id: parent_category_id!)
        } else {
         
            let data:[String: String] = [
                "product_id": String(product.id),
                "quantity": String(product.quantity),
                "ticked_off": "false"
            ]
            
            listHandler.update(list_id:selected_list_id!, list_data: data)
            
        }
       
    }
    
    func list_choosen(){
        
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
    
    @IBAction func done_pressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
}
