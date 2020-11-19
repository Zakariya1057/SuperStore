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
    func listSelected(listID: Int)
}

class ChildCategoriesViewController: TabmanViewController,GroceryDelegate, GroceriesProductsDelegate, ListSelectedDelegate {
    
    @IBOutlet var rightBarButton: UIBarButtonItem!
    let realm = try! Realm()
    
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
    
    var selectedProduct: ProductModel?
    var selectedRow: GroceryTableViewCell?
    var selectedProductID:Int?
    
    let bar = TMBar.ButtonBar()
    
    var listHandler = ListItemsHandler()
    
    var selectedListID: Int?
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = headerText
        
        groceryHandler.delegate = self
        groceryHandler.request(parentCategoryId: parentCategoryId!)
        
        if(selectedListID == nil){
            rightBarButton.title = "Select List"
        } else {
            listRequired = false
        }
        
        self.dataSource = self
        configureBar()
        
        if categoriesHistory.count > 0 && categoriesHistory[0].products.count > 0{
            
            self.viewcontrollers = []
            
            self.categories = categoriesHistory.map{$0.getCategoryModel()}
            loading = false
            
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
    
    func showGroceryItem(_ productID: Int){
        self.selectedProductID = productID
        self.performSegue(withIdentifier: K.Paths.showGroceryItem, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProductViewController
        destinationVC.productID = self.selectedProductID!
        destinationVC.selectedListID = self.selectedListID
    }
    
    func addToList(_ product: ProductModel, cell: GroceryTableViewCell?){
        
        selectedRow = cell
        
        product.parentCategoryId = parentCategoryId
        product.parentCategoryName = parentCategoryName
        
        selectedProduct = product
        
        if selectedListID == nil {
            selectLists()
        } else {
            let item = listManager.addProductToList(listID: selectedListID!, product: product)
            selectedRow!.product?.quantity = item.quantity
            selectedRow!.show_quantity_view()
            selectedRow!.configureUI()
            listHandler.create(listID: selectedListID!, listData: ["product_id": String(selectedProduct!.id)])
        }
        
        print("Adding To List")
    }
    
    func selectLists(){
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        destinationVC.delegate = self
        present(destinationVC, animated: true)
    }
    
    func listSelected(listID: Int) {
        self.selectedListID = listID
        
        if selectedProduct != nil {
            selectedRow?.show_quantity_view()
            listHandler.create(listID: listID, listData: ["product_id": String(selectedProduct!.id)])
            
            rightBarButton.isEnabled = true
            let item = listManager.addProductToList(listID: listID, product: selectedProduct!)
            selectedRow!.product?.quantity = item.quantity
            selectedRow!.show_quantity_view()
        }

        rightBarButton.title = "Change List"
        
        for viewController in viewcontrollers {
            viewController.selectedListID = listID
            viewController.tableView.reloadData()
        }
    }
    
    func updateQuantity(_ product: ProductModel) {
        
        if selectedListID != nil {
            let data:[String: String] = [
                "product_id": String(product.id),
                "quantity": String(product.quantity),
                "ticked_off": "false"
            ]
            
            listManager.updateProduct(listID: selectedListID!, product: product)
            listHandler.update(listID: selectedListID!, listData: data)
        }
        
    }
    
}

extension ChildCategoriesViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var item: TMBarItem
        
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
        
        if loading == false && categories.indices.contains(index) {
            viewController.products = categories[index].products
            viewController.selectedListID = self.selectedListID
            viewController.delegate = self
        }
        
        viewController.loading = self.loading
        
        return viewController
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        if listRequired {
            selectLists()
        } else {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 7], animated: true)
        }

    }
    
    func addToHistory(_ category: ChildCategoryModel){
        
        let categoryItem = realm.objects(ChildCategoryHistory.self).filter("id = \(category.id)").first
        
        try! realm.write() {
            let categoryHistory = category.getRealmObject()
            
            if categoryItem == nil {
                parentCategory!.childCategories.append(categoryHistory)
            } else {
                realm.delete(categoryItem!)
                parentCategory!.childCategories.append(categoryHistory)
            }
            
            // Update product/list details here.
            for product in category.products {
                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
                
                if productHistory != nil {
                    productHistory?.price = product.price
                    productHistory?.avgRating = product.avgRating
                    productHistory?.totalReviewsCount = product.totalReviewsCount
                    productHistory?.promotion = product.promotion?.getRealmObject()
                    productHistory?.largeImage = product.largeImage
                    productHistory?.smallImage = product.smallImage
                }
                
                let listItemHistory = realm.objects(ListItemHistory.self).filter("productID = \(product.id)").first
                
                if listItemHistory != nil {
                    listItemHistory?.price = product.price
                    listItemHistory?.promotion = product.promotion?.getRealmObject()
                }
                
            }
            
        }
        
    }
    
}
