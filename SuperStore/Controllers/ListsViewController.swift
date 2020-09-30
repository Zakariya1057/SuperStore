//
//  ListsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol NewListDelegate {
    func addNewList(_ list: ListModel)
}

protocol ListChangedDelegate {
    func updateList(list: ListModel, index: Int)
}

protocol ListStatusChangeDelegate {
    func updateListStatus(index: Int, status: ListStatus)
    func updatePrice(index: Int, total_price: Double)
}

class ListsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,NewListDelegate, ListDelegate, ListChangedDelegate, ListStatusChangeDelegate {

    @IBOutlet weak var listsTableView: UITableView!
    
    var listHandler = ListsHandler()
    
    var lists:[ListModel] = []
    
    var selected_list: ListModel?
    var selected_index: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    var delegate: ListSelectedDelegate?
    
    var loading: Bool = true
    let loadingCell: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listsTableView.register(UINib(nibName: K.Cells.ListCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListCell.CellIdentifier)
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
        listsTableView.rowHeight = 80
        
        listHandler.delegate = self
        listHandler.request()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        listsTableView.addSubview(refreshControl)
    
        if delegate != nil {
          self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    func updateList(list: ListModel, index: Int) {
        lists[index] = list
        self.listsTableView.reloadData()
    }

    @IBAction func addPressed(_ sender: Any) {
        performSegue(withIdentifier: "list_to_new_list", sender: self)
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        listHandler.request()
    }
    
    func contentLoaded(lists: [ListModel]) {
        self.lists = lists
        loading = false
        listsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lists.count == 0 && loading == true) ? loadingCell : lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListCell.CellIdentifier , for: indexPath) as! ListsTableViewCell
        
        if lists.indices.contains(indexPath.section) {
            cell.list = lists[indexPath.row]
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }
        
        return cell
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Deleting List?", message: "Sure you want to delete this list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.deleteList()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lists.indices.contains(indexPath.row) {
            selected_list = lists[indexPath.row]
            selected_index = indexPath.row
            
            if delegate != nil {
                self.delegate?.list_selected(list_id: selected_list!.id)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "list_to_items", sender: self)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
            selected_list = lists[indexPath.row]
            selected_index = indexPath.row
                
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, completionHandler) in
                self.confirmDelete()
                completionHandler(true)
            }

            deleteAction.backgroundColor = .systemRed


            let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
                self.performSegue(withIdentifier: "list_to_edit", sender: self)
                completionHandler(true)
            }

            editAction.backgroundColor = .systemGray
                
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            return configuration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list_to_new_list" {
            let destinationVC = segue.destination as! NewListViewController
            destinationVC.delegate = self
        } else if (segue.identifier == "list_to_items"){
            let destinationVC = segue.destination as! ListViewController
            destinationVC.list_index = selected_index
            destinationVC.status_delegate = self
            destinationVC.list_id = selected_list!.id
        } else if (segue.identifier == "list_to_edit"){
            let destinationVC = segue.destination as! ListEditViewController
            destinationVC.delegate = self
            destinationVC.list_index = selected_index
            destinationVC.list = selected_list
        }
    }
    
    func addNewList(_ list: ListModel) {
        listHandler.insert(list_data: ["name": list.name, "store_type_id": "1"])
        self.lists.insert(list,at: 0)
        self.listsTableView.reloadData()
    }
    
    func deleteList(){
        let deleted_id: String  = String(lists[selected_index].id)
        lists.remove(at: selected_index)
        listsTableView.deleteRows(at: [ IndexPath(row: selected_index, section: 0)], with: .fade)
        listHandler.delete(list_data: ["list_id": deleted_id])
    }
    
    func updateListStatus(index: Int, status: ListStatus) {
        lists[index].status = status
        listsTableView.reloadData()
    }
    
    func updatePrice(index: Int, total_price: Double) {
        lists[index].total_price = total_price
        listsTableView.reloadData()
    }
}
