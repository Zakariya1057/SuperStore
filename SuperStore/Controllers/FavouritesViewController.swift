//
//  FavouritesViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var products:[ProductModel] = []
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    var delegate:GroceryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        cell.delegate = self.delegate
        cell.product = products[indexPath.row]
        cell.showAddButton = false
        cell.showStoreName = false
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        vc.product_id = products[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if products[indexPath.row].name.count > 40 {
             return 130.0
        } else {
             return 110.0
        }
       
    }
}
