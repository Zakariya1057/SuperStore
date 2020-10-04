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
    
    var categories: [GrandParentCategoryModel] = []
    
    var selected_category: GrandParentCategoryModel?
    
    var delegate:GroceryDelegate?
    
    @IBOutlet weak var done_button: UIBarButtonItem!
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        groupTableView.dataSource = self
        groupTableView.delegate = self
        
        groceryHandler.delegate = self
        
        groceryHandler.request(store_type_id: 1)
        // Do any additional setup after loading the view.
        
        if(delegate == nil){
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }

    func contentLoaded(categories: [GrandParentCategoryModel]) {
        self.categories = categories
        loading = false
        groupTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 1 : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if loading == false {
            cell.textLabel?.text = categories[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            stopLoading(cell)
        } else {
            startLoading(cell)
        }

        return cell
    }
    
    func startLoading(_ item: UIView){
        item.isSkeletonable = true
        item.showAnimatedGradientSkeleton()
    }
    
    func stopLoading(_ item: UIView){
        item.hideSkeleton()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selected_category = categories[indexPath.row]
        self.performSegue(withIdentifier: "grandParentToParentCategories", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "grandParentToParentCategories" {
            let destinationVC = segue.destination as! ParentCategoriesViewController
            destinationVC.delegate = delegate
//            destinationVC.grandParentCategory = selected_category
            destinationVC.header_text = selected_category!.name
            destinationVC.categories = selected_category!.child_categories
        }
    }

    @IBAction func done_pressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Grocery Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
