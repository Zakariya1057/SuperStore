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
        ListProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10, quantity: 1, ticked: false),
        ListProductModel(id: 2, name: "Shazans Halal Peri Peri Chicken Thighs", image: "http://192.168.1.187/api/image/products/1000186031097_small.jpg", description: "Bread", price: 2.40, location: "Aisle B", avg_rating: 4.6, total_reviews_count: 200, quantity: 1, ticked: false),
        ListProductModel(id: 3, name: "McVitie's The Original Digestive Biscuits Twin Pack", image: "http://192.168.1.187/api/image/products/1000186031105_small.jpg", description: "Bread", price: 3.40, location: "Aisle C", avg_rating: 2.2, total_reviews_count: 132, quantity: 1, ticked: false),
        ListProductModel(id: 4, name: "Ben & Jerry's Non-Dairy & Vegan Chocolate Fudge Brownie Ice Cream", image: "http://192.168.1.187/api/image/products/910001256210_small.jpg", description: "Bread", price: 4.40, location: "Aisle D", avg_rating: 1.5, total_reviews_count: 1, quantity: 12, ticked: false),
        ListProductModel(id: 5, name: "ASDA Extra Special Chilli Pork Sausage Ladder", image: "http://192.168.1.187/api/image/products/910001256396_small.jpg", description: "Bread", price: 5.40, location: "Aisle E", avg_rating: 4.1, total_reviews_count: 122, quantity: 1, ticked: false),
        ListProductModel(id: 6, name: "Preema Disposable Face Coverings 5 x 4 Packs (20 Coverings)", image: "http://192.168.1.187/api/image/products/910001256410_small.jpg", description: "Bread", price: 6.40, location: "Aisle F", avg_rating: 4.4, total_reviews_count: 11, quantity: 1, ticked: false),
        ListProductModel(id: 7, name: "Nivea Sun Kids Suncream Spray SPF 50+ Coloured", image: "http://192.168.1.187/api/image/products/910001257216_small.jpg", description: "Bread", price: 7.40, location: "Aisle G", avg_rating: 3.4, total_reviews_count: 123, quantity: 3, ticked: false)
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
