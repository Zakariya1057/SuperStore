//
//  SearchStoresTableViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchStoresViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, SearchResultsDelegate, StoreSelectedDelegate {

    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var storesTableView: UITableView!
    
    var stores: [StoreModel] = []
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var store_type_id: Int?
    
    var selected_store_id: Int?
    
    var loading: Bool = true
    
    var delegate: GroceryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapTableView.delegate = self
        self.mapTableView.dataSource = self
        
        self.storesTableView.delegate = self
        self.storesTableView.dataSource = self

        mapTableView.register(UINib(nibName: K.Cells.StoreMapCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoreMapCell.CellIdentifier)
        storesTableView.register(UINib(nibName: K.Cells.StoresResultsCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoresResultsCell.CellIdentifier)
        
        searchHandler.resultsDelegate = self
        searchHandler.requestResults(searchData: ["type": "stores", "detail": String(store_type_id!)])
        storesTableView.rowHeight = 100;
        mapTableView.rowHeight = 300
        
    }

    func errorHandler(_ message: String) {
        loading = false
        showError(message)
        storesTableView.reloadData()
    }
    
    func contentLoaded(stores: [StoreModel], products: [ProductModel], filters: [RefineOptionModel], paginate: PaginateResultsModel?) {
        self.stores = stores
        loading = false
        storesTableView.reloadData()
        mapTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == storesTableView {
            return loading ? 5 : stores.count
        } else if tableView == mapTableView {
            return 1
        }
        
        return 0
    }
    
    func storePressed(store_id: Int) {
        
        for (index, store) in stores.enumerated() {
            if store.id == store_id {
                let indexPath = NSIndexPath(row: index, section: 0)
                storesTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mapTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.StoreMapCell.CellIdentifier) as! StoresMapTableViewCell
            cell.stores = stores
            cell.delegate = self
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if tableView ==  storesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.StoresResultsCell.CellIdentifier) as! StoresResultsTableViewCell
            
            if loading == false {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.store = stores[indexPath.row]
                cell.configureUI()
            } else {
                cell.startLoading()
            }

            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if loading == true {
            return
        }
        
        if tableView == storesTableView {
            storeSelected(store_id: stores[indexPath.row].id)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storeResultsToStore" {
            let destinationVC = segue.destination as! StoreViewController
            destinationVC.store_id = selected_store_id!
            destinationVC.delegate = self.delegate
        }
    }
    
    func storeSelected(store_id: Int) {
        selected_store_id = store_id
        self.performSegue(withIdentifier: "storeResultsToStore", sender: self)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Search Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
