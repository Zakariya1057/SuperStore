//
//  GroceryViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class GroceryTableViewController: UITableViewController {

//    let items:[String] = ["Burger","Bread","Toast"]
    
    var products:[ListProductModel] = [
        ListProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "", description: "Bread", price: 1.40, location: "Aisle A", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Shazans Halal Peri Peri Chicken Thighs", image: "", description: "Bread", price: 2.40, location: "Aisle B", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "McVitie's The Original Digestive Biscuits Twin Pack", image: "", description: "Bread", price: 3.40, location: "Aisle C", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Ben & Jerry's Non-Dairy & Vegan Chocolate Fudge Brownie Ice Cream", image: "", description: "Bread", price: 4.40, location: "Aisle D", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "ASDA Extra Special Chilli Pork Sausage Ladder", image: "", description: "Bread", price: 5.40, location: "Aisle E", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Preema Disposable Face Coverings 5 x 4 Packs (20 Coverings)", image: "", description: "Bread", price: 6.40, location: "Aisle F", quantity: 1, ticked: false),
        ListProductModel(id: 3, name: "Nivea Sun Kids Suncream Spray SPF 50+ Coloured", image: "", description: "Bread", price: 7.40, location: "Aisle G", quantity: 3, ticked: false)
    ]
    
    
    var delegate:GroceryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        cell.delegate = self.delegate
        cell.product = products[indexPath.row]
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.delegate?.showGroceryItem()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0;//Choose your custom row height
    }
}
