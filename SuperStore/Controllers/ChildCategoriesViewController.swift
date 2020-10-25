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
    
//    var list_delegate: GroceryDelegate?
    
    var groceryHandler = GroceryProductsHandler()
    
    var parentCategoryId: Int?
    var parentCategoryName: String? // Set this in parent and pass to child
    
    var viewcontrollers:[GroceryTableViewController] = [ GroceryTableViewController() ]
    
    var headerText:String?
    
    var categories: [ChildCategoryModel] = []
    
    var userHandler = UserHandler()
    
    var categoriesHistory: Results<ChildCategoryHistory> {
        get {
            return realm.objects(ChildCategoryHistory.self).filter("parentCategoryId = \(parentCategoryId!)")
        }
    }
    
    var parentCategory: ParentCategoryHistory? {
        get {
            return realm.objects(ParentCategoryHistory.self).filter("id = \(parentCategoryId!)").first
        }
    }
    
    var listRequired: Bool = true
    var listManager: ListManager = ListManager()
    
    var selected_product: ProductModel?
    var selected_row: GroceryTableViewCell?
    var selected_product_id:Int?
    
    // Create bar
    let bar = TMBar.ButtonBar()
    
    var listHandler = ListItemsHandler()
    
    var add_to_list_product_index: Int?
    
    var selectedListId: Int?
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = headerText
        
        groceryHandler.delegate = self
        groceryHandler.request(parentCategoryId: parentCategoryId!)
        
        if(selectedListId == nil){
            self.navigationItem.rightBarButtonItem = nil
        } else {
            listRequired = false
        }
        
        self.dataSource = self
        configureBar()
        
        if categoriesHistory.count > 0 && categoriesHistory[0].products.count > 0{
            print("Found In History")
            
            self.viewcontrollers = []
            
            self.categories = categoriesHistory.map{$0.getCategoryModel()}
            loading = false
            
            print(self.categories)
            for _ in categories {
                viewcontrollers.append(GroceryTableViewController())
            }
            
            self.reloadData()
        } else {
            viewcontrollers = [GroceryTableViewController()]
        }
        
    }
    
    func contentLoaded(child_categories: [ChildCategoryModel]) {
        
        loading = false
        
        if child_categories.count > 0 {
            
            viewcontrollers = []
            
            self.categories = child_categories
            
            if loading == false {
                for _ in child_categories {
                    self.viewcontrollers.append(GroceryTableViewController())
                }

                self.reloadData()
            }

            for category in child_categories {
                addToHistory(category)
            }
            
        } else {
            self.viewcontrollers[0].loading = false
            self.viewcontrollers[0].tableView.reloadData()
            self.reloadData()
        }

    }
    
    func errorHandler(_ message: String) {
        loading = false
        showError(message)
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
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
        destinationVC.product_id = self.selected_product_id!
        destinationVC.selectedListId = self.selectedListId
    }
    
    func addToList(_ product: ProductModel, cell: GroceryTableViewCell?){
        
        selected_row = cell
        
        product.parentCategoryId = parentCategoryId
        product.parentCategoryName = parentCategoryName
        
        selected_product = product
        
        if listRequired {
            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            destinationVC.delegate = self
            present(destinationVC, animated: true)
        } else {
            let item = listManager.addProductToList(listId: selectedListId!, product: product)
            selected_row!.product?.quantity = item.quantity
            selected_row!.show_quantity_view()
            selected_row!.configureUI()
            listHandler.create(list_id: selectedListId!, list_data: ["product_id": String(selected_product!.id)])
        }
        
        print("Adding To List")
    }
    
    func listSelected(list_id: Int) {
        self.selectedListId = list_id
        selected_row?.show_quantity_view()
        listHandler.create(list_id: list_id, list_data: ["product_id": String(selected_product!.id)])
        
        let item = listManager.addProductToList(listId: list_id, product: selected_product!)
        selected_row!.product?.quantity = item.quantity
        selected_row!.show_quantity_view()
    }

    func updateQuantity(_ product: ProductModel) {

        if selectedListId != nil {
            let data:[String: String] = [
                "product_id": String(product.id),
                "quantity": String(product.quantity),
                "ticked_off": "false"
            ]
            
            listManager.updateProduct(listId: selectedListId!, product: product)
            listHandler.update(listId:selectedListId!, listData: data)
        }
       
    }
    
}

extension ChildCategoriesViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var item: TMBarItem
        
        print("Bar Loading: \(loading)")
        if loading == false && categories.indices.contains(index) {
            item = TMBarItem(title: categories[index].name)
        } else {
            item = TMBarItem(title: "")
            item.image = nil
        }

        return item
    }
    

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return loading ? 1 : viewcontrollers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let viewController: GroceryTableViewController = loading ? viewcontrollers[0]: viewcontrollers[index]

        print("Generate View Controllers")
        
        if loading == false && categories.indices.contains(index) {
            viewController.products = categories[index].products
            viewController.selectedListId = self.selectedListId
            viewController.delegate = self
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
    
    func addToHistory(_ category: ChildCategoryModel){

        let categoryItem = realm.objects(ChildCategoryHistory.self).filter("id = \(category.id)").first
        
        try! realm.write() {
            if categoryItem == nil {
                parentCategory!.childCategories.append(category.getRealmObject())
            } else {
                realm.delete(categoryItem!)
                parentCategory!.childCategories.append(category.getRealmObject())
            }
            
        }
        
    }
    
}
