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
import RealmSwift

protocol ListSelectedDelegate {
    func listSelected(list_id: Int)
}

class ChildCategoriesViewController: TabmanViewController,GroceryDelegate, GroceriesProductsDelegate, ListSelectedDelegate {

    let realm = try! Realm()
    
    var list_delegate: GroceryDelegate?
    
    var groceryHandler = GroceryProductsHandler()
    
    var parent_category_id: Int?
    var parent_category_name: String? // Set this in parent and pass to child
    
    var viewcontrollers:[GroceryTableViewController] = []
    
    var header_text:String?
    
    var categories: [ChildCategoryModel] = []
    
    var categoriesHistory: Results<ChildCategoryHistory> {
        get {
            return realm.objects(ChildCategoryHistory.self).filter("parentCategoryId = \(parent_category_id!)")
        }
    }
    
    var parentCategory: ParentCategoryHistory? {
        get {
            return realm.objects(ParentCategoryHistory.self).filter("id = \(parent_category_id!)").first
        }
    }
    
    
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
        
        self.title = ""
        
        groceryHandler.delegate = self
        groceryHandler.request(parent_category_id: parent_category_id!)
        
        if(list_delegate == nil){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.dataSource = self
        configureBar()
        
        if categoriesHistory.count > 0 {
            print("Found In History")
            self.categories = categoriesHistory.map{$0.getCategoryModel()}
            configureUI()
            
            for _ in categories {
                viewcontrollers.append(GroceryTableViewController())
            }
            
            self.reloadData()
        }
        
    }
    
    func errorHandler(_ message: String) {
        loading = false
        showError(message)
    }
    
    func contentLoaded(child_categories: [ChildCategoryModel]) {
        self.categories = child_categories
        configureUI()
        
        if loading == false {
            for _ in child_categories {
                viewcontrollers.append(GroceryTableViewController())
            }

            self.reloadData()
        }
        
        // Adding to history will take longer, run afterwards
        for category in child_categories {
            addToHistory(category)
        }
    
    }
    
    func configureUI(){
        loading = false
        self.title = header_text
    }
    
    func reloadControllers(){
        
    }
    
    func configureBar(){
        bar.tintColor = UIColor(named: "Label Color")
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 1.0, right: 16.0)
        bar.layout.interButtonSpacing = 30.0
        
        bar.layout.showSeparators = true
        bar.layout.separatorColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        bar.layout.separatorWidth = 0.5
        
        bar.backgroundView.style = .flat(color:  UIColor(named: "LightGrey")!)
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
    
    func listSelected(list_id: Int) {
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
            
            listHandler.update(listId:selected_list_id!, listData: data)
            
        }
       
    }

    
}



extension ChildCategoriesViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var item: TMBarItem
        
        if loading == false {
            item = TMBarItem(title: categories[index].name)
        } else {
            item = TMBarItem(title: "")
            item.image = nil
        }

        return item
    }
    

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return loading ? 1 : categories.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
       
        var viewController: GroceryTableViewController
        
        if loading == false {
            viewController = viewcontrollers[index]
            viewController.products = categories[index].products
            viewController.delegate = self
        } else {
            viewController = GroceryTableViewController()
        }

        viewController.loading = self.loading
        
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
    
    func addToHistory(_ category: ChildCategoryModel){
    
        var categoryItem = realm.objects(ChildCategoryHistory.self).filter("id = \(category.id)").first
        print("Adding To History")
        
        try! realm.write() {
            if categoryItem == nil {
                parentCategory!.childCategories.append(category.getRealmObject())
            } else {
                categoryItem! = category.getRealmObject()
                
                categoryItem!.products.removeAll()
                
                for product in category.products {
                    categoryItem!.products.append(product.getRealmObject())
                }
                
            }
            
        }
        
    }
    
}
