//
//  GroceryGroupViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class GrandParentCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,GroceriesCategoriesDelegate {

    var groceryHandler = GroceryCategoriesHandler()
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var categories: [GroceryCategoriesModel] = []
    
    var selected_category: GroceryCategoriesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        groupTableView.dataSource = self
        groupTableView.delegate = self
        
        groceryHandler.delegate = self
        
        groceryHandler.request(store_type_id: 1)
        // Do any additional setup after loading the view.
    }
    

    func contentLoaded(categories: [GroceryCategoriesModel]) {
        self.categories = categories
        groupTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selected_category = categories[indexPath.row]
        self.performSegue(withIdentifier: "grandParentToParentCategories", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "grandParentToParentCategories" {
            let destinationVC = segue.destination as! ParentCategoriesViewController
            destinationVC.header_text = selected_category!.name
            destinationVC.categories = selected_category!.child_categories
        }
    }


}
