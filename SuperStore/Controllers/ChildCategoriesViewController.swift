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

    var parentCategory: ChildCategoryModel?
    
    var list_delegate: GroceryDelegate?
    
    var groceryHandler = GroceryProductsHandler()
    
    var parent_category_id: Int?
    var parent_category_name: String? // Set this in parent and pass to child
    
    var headers:[String] = []
    var viewcontrollers:[GroceryTableViewController] = []
    
    var header_text:String?
    
    var categories: [GroceryProductsModel] = []
    
    var selected_product_id:Int?
    
    var selected_row: GroceryTableViewCell?
    
    // Create bar
    let bar = TMBar.ButtonBar()
    
    var listHandler = ListItemsHandler()
    
    var add_to_list_product_index: Int?
    
    var selected_list_id: Int?
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groceryHandler.delegate = self
        groceryHandler.request(parent_category_id: parent_category_id!)
        
        if(list_delegate == nil){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.dataSource = self
        configureUI()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        showError(message)
    }
    
    func contentLoaded(categories: [GroceryProductsModel]) {
        self.categories = categories
        loading = false
        
        for category in categories {
            headers.append(category.name)
            viewcontrollers.append(GroceryTableViewController())
        }
        
        self.reloadData()
    }
    
    func configureUI(){
        
        self.title = header_text
        
        bar.tintColor = UIColor(named: "Label Color")
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 1.0, right: 16.0)
        bar.layout.interButtonSpacing = 30.0
        
        bar.layout.showSeparators = true
        bar.layout.separatorColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        bar.layout.separatorWidth = 0.5
        
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor(named: "LightGrey")
        
        bar.indicator.weight = .medium
        bar.indicator.cornerStyle = .square
        bar.fadesContentEdges = true
        bar.spacing = 30.0

        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Grocery Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
        destinationVC.delegate = self.list_delegate
    }
    
    func removeFromList(_ product: ProductModel) {
        
    }
    
    func addToList(_ product: ProductModel, cell: GroceryTableViewCell?){
        
        selected_row = cell
        
        if list_delegate != nil {
            product.parent_category_id = parentCategory!.id
            product.parent_category_name = parentCategory!.name
            product.quantity = 1
            list_delegate?.addToList(product, cell: cell)
        } else {
            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            destinationVC.delegate = self
            
            self.present(destinationVC, animated: true)
            self.add_to_list_product_index = product.id
        }
        
        print("Adding To List")
    }
    
    func list_selected(list_id: Int) {
        self.selected_list_id = list_id
        selected_row?.show_quantity_view()
        listHandler.create(list_id: list_id, list_data: ["product_id": String(add_to_list_product_index!)])
    }
    
    func remove_from_list(_ product: ProductModel) {
        product.parent_category_id = parentCategory!.id
        product.parent_category_name = parentCategory!.name
        
        list_delegate!.removeFromList(product)
    }
    
    func updateQuantity(_ product: ProductModel) {

        if list_delegate != nil {
            product.parent_category_id = parentCategory!.id
            product.parent_category_name = parentCategory!.name
            
            list_delegate?.updateQuantity(product)
        } else if selected_list_id != nil {
         
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
        var item: TMBarItem
        
        if loading == false {
            item = TMBarItem(title: headers[index])
        } else {
            item = TMBarItem(title: "")
            item.image = nil
        }

        return item
    }
    

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return loading ? 1 : headers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
       
        var viewController: GroceryTableViewController
        
        if loading == false {
            viewController = viewcontrollers[index]
            viewController.products = categories[index].products
            viewController.delegate = self
            viewController.loading = false
        } else {
            viewController = GroceryTableViewController()
            viewController.loading = true
        }

        return viewController
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    @IBAction func done_pressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 7], animated: true)
    }
    
    func startLoading(_ item: UIView){
        item.isSkeletonable = true
        item.showAnimatedGradientSkeleton()
    }
    
    func stopLoading(_ item: UIView){
        item.hideSkeleton()
    }
}
