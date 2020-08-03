//
//  FavouritesViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var products:[ListProductModel] = [
        ListProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "", description: "Bread", price: 1.40, location: "Aisle A", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Shazans Halal Peri Peri Chicken Thighs", image: "", description: "Bread", price: 2.40, location: "Aisle B", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "McVitie's The Original Digestive Biscuits Twin Pack", image: "", description: "Bread", price: 3.40, location: "Aisle C", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Ben & Jerry's Non-Dairy & Vegan Chocolate Fudge Brownie Ice Cream", image: "", description: "Bread", price: 4.40, location: "Aisle D", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "ASDA Extra Special Chilli Pork Sausage Ladder", image: "", description: "Bread", price: 5.40, location: "Aisle E", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Preema Disposable Face Coverings 5 x 4 Packs (20 Coverings)", image: "", description: "Bread", price: 6.40, location: "Aisle F", quantity: 1, ticked: false),
        ListProductModel(id: 3, name: "Nivea Sun Kids Suncream Spray SPF 50+ Coloured", image: "", description: "Bread", price: 7.40, location: "Aisle G", quantity: 3, ticked: false)
    ]
    
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
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
         self.navigationController?.pushViewController(vc, animated: true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if products[indexPath.row].name.count > 40 {
             return 140.0;//Choose your custom row height
        } else {
             return 120.0;//Choose your custom row height
        }
       
    }
}
