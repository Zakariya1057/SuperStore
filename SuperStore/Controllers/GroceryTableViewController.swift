//
//  GroceryViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class GroceryTableViewController: UITableViewController, QuanityChangedDelegate {

    var products: [ProductModel]?
    
    var delegate:GroceryDelegate?
    
    var grandParentCategory: GrandParentCategoryModel?
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 3: products!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if loading == false {
            cell.delegate = self.delegate
            cell.quantity_delegate = self
            cell.product = products![indexPath.row]
            cell.index = indexPath.row
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.showGroceryItem(products![indexPath.row].id)
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130.0;
//    }
    
    func updateProductQuantity(index: Int, quantity: Int) {
        self.delegate?.updateQuantity(products![index])
    }
    
}
