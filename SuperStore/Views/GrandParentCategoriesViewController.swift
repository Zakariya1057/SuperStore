//
//  GroceryGroupViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class GrandParentCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,GroceriesCategoriesDelegate {

    let realm = try! Realm()
    
    lazy var categories: Results<GrandParentCategoryHistory> = { self.realm.objects(GrandParentCategoryHistory.self).filter("store_type_id = \(store_type_id!)").sorted(byKeyPath: "id", ascending: false)}()
    
    var store_type_id: Int?
    
    var groceryHandler = GroceryCategoriesHandler()
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var userHandler = UserHandler()
    
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
        
        if categories.count > 0 {
            configureUI()
        }
    }
    
    func contentLoaded(categories: [GrandParentCategoryModel]) {
        
        for category in categories {
            self.addToHistory(category)
        }
        
        configureUI()
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }

    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    func configureUI(){
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
        selected_category = categories[indexPath.row].getCategoryModel()
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
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Grocery Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func addToHistory(_ category: GrandParentCategoryModel){
        
        let categoryItem = categories.first { (categoryHistory) -> Bool in
            categoryHistory.id == category.id
        }
        
        try! realm.write() {
            if categoryItem == nil {
                realm.add(category.getRealmObject())
            } else {

            }
            
        }
        
        
    }
    
}
