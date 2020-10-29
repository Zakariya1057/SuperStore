//
//  GroceryGroupViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ParentCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var groceryHandler = GroceryCategoriesHandler()
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var categories: [ParentCategoryModel]?
    var header_text: String?
    
    var selected_category: ParentCategoryModel?
    
    var selectedListId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        self.title = header_text!
        
        groupTableView.dataSource = self
        groupTableView.delegate = self
        
        if(selectedListId == nil){
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories![indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_category = categories![indexPath.row]
        self.performSegue(withIdentifier: "parentCategoriesToProducts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parentCategoriesToProducts" {
            let destinationVC = segue.destination as! ChildCategoriesViewController
            destinationVC.selectedListId = selectedListId
            destinationVC.parentCategoryId = selected_category!.id
            destinationVC.parentCategoryName = selected_category!.name
            destinationVC.headerText = selected_category!.name
        }
    }
    
    @IBAction func done_pressed(_ sender: Any) {
         let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
         self.navigationController!.popToViewController(viewControllers[viewControllers.count - 6], animated: true)
    }

}
