//
//  Choose your custom row height     } ListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol PriceChangeDelegate {
    func productChanged(section_index: Int,row_index:Int, product: ListItemModel)
    func calculateProductPrice(_ product: ListItemModel) -> Double
}

//protocol StoreSelectedDelegate {
//    func storeChanged(name: String,backgroundColor: UIColor)
//}

//protocol NewProductDelegate {
//    func productAdded(product: ProductModel,parent_category_id: Int,parent_category_name: String)
//    func productRemoved(product: ProductModel, parent_category_id: Int)
//    func productQuantityChanged(product: ProductModel,parent_category_id: Int)
//}

protocol ProductQuantityChangedDelegate {
    func quantityChanged(section_index: Int,row_index:Int, quantity: Int)
    func calculateProductPrice(_ product: ListItemModel) -> Double
    func removeItem(section: Int, row: Int)
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PriceChangeDelegate, ProductQuantityChangedDelegate, ListItemsDelegate {

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var listHandler = ListItemsHandler()
    
    var list: ListModel?
    
    var list_index: Int = 0
    
    var delegate:PriceChangeDelegate?
    
    var status_delegate: ListStatusChangeDelegate?
    
    @IBOutlet weak var editBarItem: UIBarButtonItem!
    
    @IBOutlet weak var listTableView: UITableView!

    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    var selected_row: Int = 0
    var selected_section: Int = 0
    
    var list_id: Int = 1
    
    var items:[ListItemModel] {
        return self.list?.categories.flatMap { $0.items } ?? []
    }
    
    var refreshControl = UIRefreshControl()
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.Sections.ListHeader.SectionNibName, bundle: nil)
        self.listTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.ListHeader.SectionIdentifier)
        
        self.listTableView.register(UINib(nibName: K.Cells.ListItemCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListItemCell.CellIdentifier)
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        showTotalPrice()
        
        listHandler.delegate = self
        listHandler.request(list_id:list_id)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
         refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
         listTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    

    func contentLoaded(list: ListModel) {
        self.list = list
        self.title = list.name
        loading = false
        showTotalPrice()
        listTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        listTableView.reloadData()
        refreshControl.endRefreshing()
        showError(message)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        listHandler.request(list_id:list_id)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "searchViewController"))! as! SearchViewController
        destinationVC.delegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func showTotalPrice(){
        var price:Double = 0.00
        let products = (list?.categories ?? []).map({ $0.items }).joined()
        
        print(products.count)
        for product in products {
            print(product.price)
            price += calculateProductPrice(product)
        }
        
        self.totalPriceLabel.text = "£" + String(format: "%.2f", price)
        
        self.status_delegate?.updatePrice(index: list_index, total_price: price)
    }
        
    func productChanged(section_index: Int,row_index:Int, product: ListItemModel) {
        list!.categories[section_index].items[row_index] = product
        showTotalPrice()
        productUpdate(product: product)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "List Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension ListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if loading != true {
            return list?.categories.count ?? 0
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = indexPath.row
        selected_section = indexPath.section
        self.performSegue(withIdentifier: "list_item_details", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeItem(section: indexPath.section, row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = listTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.ListHeader.SectionIdentifier) as! ListSectionHeader
        
        if loading == true {
            header.headingLabel.text = ""
        } else {
            let section_item = list!.categories[section]
            let title = section_item.name
            let subtitle = section_item.aisle_name ?? ""

            header.headingLabel.text = title
            header.subHeadingLabel.text = subtitle
        }

        return header
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading != true {
            return list?.categories[section].items.count ?? 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListItemCell.CellIdentifier , for: indexPath) as! ListItemTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        if loading != true {
            cell.product = list!.categories[indexPath.section].items[indexPath.row]
            cell.productIndex = indexPath.row
            cell.delegate = self
            
            cell.section_index = section
            cell.row_index = row
            
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }
        
        return cell
    }
}

extension ListViewController: GroceryDelegate {
    
    func productRemoved(product: ProductModel, parent_category_id: Int) {
        print("Remove Product")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list_item_details" {
            let destinationVC = segue.destination as! ListItemViewController
            destinationVC.selected_row = selected_row
            destinationVC.selected_section = selected_section

            destinationVC.delegate = self
            destinationVC.product = list!.categories[selected_section].items[selected_row]
        }
    }
    
    func showGroceryItem(_ product_id: Int) {
        
    }
    
    func addToList(_ product: ProductModel) {
        productAdded(product: product, parent_category_id: product.parent_category_id!, parent_category_name: product.parent_category_name!)
    }
    
    func removeFromList(_ product: ProductModel) {
        
    }
    
    func updateQuantity(_ product: ProductModel) {
        productQuantityChanged(product: product, parent_category_id: product.parent_category_id!)
    }
    
    func calculateProductPrice(_ product: ListItemModel) -> Double {
        var price:Double = 0
        
        if product.discount == nil {
            print("No Discount Found")
            price = ( Double(product.quantity) * product.price)
        } else {
            print("Discount Found")
            
            let discount = product.discount

            let remainder = (product.quantity % discount!.quantity)
            let goesIntoFully = round(Double(Int(product.quantity) / Int(discount!.quantity)))

            if product.quantity < discount!.quantity {
                price += Double(product.quantity) * product.price
            }
            
            if discount!.forQuantity != nil {
                price = (Double(goesIntoFully) * (Double(discount!.forQuantity!) * product.price) ) + (Double(remainder) * product.price)
            } else if (discount!.price != nil){
                price = (Double(goesIntoFully) * discount!.price!) + (Double(remainder) * product.price)
            }
            
        }
        
        return price
    }
    
    func removeItem(section: Int, row: Int){

        print("Section: \(section)")
        print("Row: \(row)")
        
        let product = list!.categories[section].items[row]
        
        let indexPath = IndexPath(row: row, section: section)
        let indexSet = NSIndexSet(index: section)
        
        if list!.categories[section].items.count == 1 {
            list!.categories.remove(at: section)
            listTableView.deleteSections(indexSet as IndexSet, with: .fade)
        } else {
            list!.categories[section].items.remove(at: row)
            listTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
//        listTableView.reloadData()
//        reload()
        
        listHandler.delete(list_id: list_id, list_data: ["product_id": String(product.product_id)])
        
        showTotalPrice()
    }
    
    func reload(){
        UIView.setAnimationsEnabled(false)
        self.listTableView.beginUpdates()
        self.listTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableView.RowAnimation.none)
        self.listTableView.endUpdates()
    }
    
    func productQuantityChanged(product: ProductModel, parent_category_id: Int){
        print("Update Product Quantity")
        
        let categories = list?.categories ?? []
        
        for (cat_index, category) in categories.enumerated() {
            if category.id == parent_category_id {
                
                
                for (prod_index, product_item) in category.items.enumerated() {
                    if product_item.product_id == product.id {
                        print("Updating Found Product")
                        print(product.quantity)
                        list?.categories[cat_index].items[prod_index].quantity = product.quantity
                        productUpdate(product: (list?.categories[cat_index].items[prod_index])!)
                        break
                    }
                }

            }
            
        }
        
        showTotalPrice()
    }
    
    func productAdded(product: ProductModel,parent_category_id: Int,parent_category_name: String) {
        
        if product_exists(product.id) {
            return
        }
        
        var categories = list?.categories ?? []
        
        let item = ListItemModel(id: product.id, name: product.name, total_price: product.price, price: product.price, product_id: product.id, quantity: 1, image: product.image, ticked_off: false, weight: product.weight,discount: product.discount)
        var added: Bool = false
        
        if categories.count > 0 {
            
            for (index, category) in categories.enumerated() {
                if category.id == parent_category_id {
                    list?.categories[index].items.append(item)
                    added = true
                    break
                }
            }
            
        }
        
        categories = list?.categories ?? []
        
        if(!added){
            let category = ListCategoryModel(id: parent_category_id, name: parent_category_name, aisle_name: "", items: [item])
            categories.append(category)
        }
        
        list?.categories = categories.sorted(by: {$0.id < $1.id })
        
        listHandler.create(list_id: list_id, list_data: ["product_id": String(product.id)])
        
        if listTableView != nil {
            listTableView.reloadData()
        }
        
        showTotalPrice()
    }
    
    
    func quantityChanged(section_index: Int,row_index:Int, quantity: Int) {
        var product = list!.categories[selected_section].items[selected_row]
        product.quantity = quantity
        list!.categories[selected_section].items[selected_row] = product
        listTableView.reloadData()
        showTotalPrice()
        productUpdate(product: product)
    }
    
    func productUpdate(product: ListItemModel){

        let data:[String: String] = [
            "product_id": String(product.product_id),
            "quantity": String(product.quantity),
            "ticked_off": String(product.ticked_off)
        ]
        
        listHandler.update(list_id: list_id, list_data: data)
        
        completedCheck()
    }
    
    func product_exists(_ product_id: Int) -> Bool {
        // Checks if products exists in list
        for item in self.items {
            if item.product_id == product_id {
                return true
            }
        }
        
        return false
    }
    
    func completedCheck(){
        //Check if all products completed. If the case then update the parent
        var checkedItems = 0
        var allItems = 0
        
        for item in items {
            
            allItems += 1
            
            if item.ticked_off == true {
                checkedItems += 1
            }
        }
        
        var status: ListStatus = .notStarted
        
        if (allItems > 0){
           if(checkedItems == allItems){
               status = .completed
           } else if checkedItems > 0 {
               status = .inProgress
           }
        }
        
        self.status_delegate?.updateListStatus(index: list_index, status: status)
        
    }
    
}
