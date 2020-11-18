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
    
    lazy var categories: Results<GrandParentCategoryHistory> = { self.realm.objects(GrandParentCategoryHistory.self).filter("storeTypeID = \(storeTypeID!)").sorted(byKeyPath: "id", ascending: true)}()
    
    var storeTypeID: Int?
    
    var groceryHandler = GroceryCategoriesHandler()
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var userHandler = UserHandler()
    
    var selectedCategory: GrandParentCategoryModel?
    
    var selectedListID: Int?
    
    @IBOutlet weak var done_button: UIBarButtonItem!
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        groupTableView.dataSource = self
        groupTableView.delegate = self
        
        groceryHandler.delegate = self
        
        groceryHandler.request(storeTypeID: 1)
        
        if(selectedListID == nil){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if categories.count > 0 {
            configureUI()
        }
    }
    
    func contentLoaded(categories: [GrandParentCategoryModel]) {
        self.addToHistory(categories)
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
        return loading ? 5 : categories.count
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
        self.selectedCategory = categories[indexPath.row].getCategoryModel()
        self.performSegue(withIdentifier: "grandParentToParentCategories", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "grandParentToParentCategories" {
            let destinationVC = segue.destination as! ParentCategoriesViewController
            destinationVC.selectedListID = selectedListID
            destinationVC.headerText = selectedCategory!.name
            destinationVC.categories = selectedCategory!.childCategories
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
    
    func addToHistory(_ categories: [GrandParentCategoryModel]){
        
        try? realm.write({
            
            for grandParentCategory in categories {
                let grandParentCategoryHistory = realm.objects(GrandParentCategoryHistory.self).filter("id = \(grandParentCategory.id)").first
                
                if grandParentCategoryHistory == nil {
                    realm.add(grandParentCategory.getRealmObject())
                } else {
                    
                    for category in grandParentCategory.childCategories {
                        let categoryHistory = realm.objects(ParentCategoryHistory.self).filter("id = \(category.id)").first
                        
                        if categoryHistory == nil {
                            grandParentCategoryHistory!.childCategories.append(category.getRealmObject())
                        }
                    }
                }
            }
            
        })
        
    }
    
}
