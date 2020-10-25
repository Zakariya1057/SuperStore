//
//  GroceryViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class GroceryTableViewController: UITableViewController, QuanityChangedDelegate {

    var products: [ProductModel] = []
    
    let realm = try! Realm()
    
    var parentCategoryId: Int?
    
    var delegate:GroceryDelegate?
    
    var grandParentCategory: GrandParentCategoryModel?
    
    var loading: Bool = true
    
    var selectedListId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loading: \(loading)")
        
        tableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 5: products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if loading == false {
            cell.delegate = self.delegate
            cell.quantity_delegate = self
            cell.product = products[indexPath.row]
            
            if selectedListId != nil {
                let listItem = realm.objects(ListItemHistory.self).filter("list_id = \(selectedListId!) AND product_id=\( cell.product!.id )").first
                
                if listItem != nil {
                    cell.product!.quantity = listItem!.quantity
                }
            }
            
            cell.index = indexPath.row
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.showGroceryItem(products[indexPath.row].id)
    }

    func updateProductQuantity(index: Int, quantity: Int) {
        self.delegate?.updateQuantity(products[index])
    }
    
}
