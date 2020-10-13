//
//  ListsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

protocol NewListDelegate {
    func addNewList(_ list: ListModel)
}

//protocol ListChangedDelegate {
//    func updateList(list: ListModel, index: Int)
//}
//
//protocol ListStatusChangeDelegate {
//    func updateListStatus(index: Int, status: ListStatus)
//    func updatePrice(index: Int, total_price: Double)
//}

class ListsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,NewListDelegate, ListDelegate {

    @IBOutlet weak var listsTableView: UITableView!
    
    var listHandler = ListsHandler()
    
//    var lists:[ListModel] = []
    
    let realm = try! Realm()
    lazy var lists: Results<ListHistory> = { self.realm.objects(ListHistory.self).sorted(byKeyPath: "created_at", ascending: false)}()
    
    var selected_list: ListModel?
    var selected_index: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    var delegate: ListSelectedDelegate?
    
    var loading: Bool = true
    let loadingCell: Int = 1
    
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listsTableView.register(UINib(nibName: K.Cells.ListCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListCell.CellIdentifier)
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
//        listsTableView.rowHeight = 70
        
        listHandler.delegate = self
        listHandler.request()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        listsTableView.addSubview(refreshControl)
    
        let results = realm.objects(ListHistory.self)

        // Observe Results Notifications
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    self?.listsTableView.reloadData()
            case .update(_, _, _, _):
                    self?.listsTableView.reloadData()
                    break
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
            }
        }
        
        if delegate != nil {
          self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    func contentLoaded(lists: [ListModel]) {
        
        for list in lists {
            addUpdateList(list: list)
        }

        loading = false
        listsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        showError(message)
        listsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func updateList(list: ListModel, index: Int) {
        let listItem = lists[index]
        listItem.status = list.status.rawValue
        self.listsTableView.reloadData()
    }

    @IBAction func addPressed(_ sender: Any) {
        performSegue(withIdentifier: "list_to_new_list", sender: self)
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        listHandler.request()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? loadingCell : lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListCell.CellIdentifier , for: indexPath) as! ListsTableViewCell
        
        if !loading {
            cell.list = lists[indexPath.row].getListModel()
        }
        
        print("Loading: \(loading)")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.loading = loading
        cell.configureUI()
        
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
            selected_list = lists[indexPath.row].getListModel()
            selected_index = indexPath.row
            
            if delegate != nil {
                self.delegate?.listSelected(list_id: selected_list!.id)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "list_to_items", sender: self)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
            selected_list = lists[indexPath.row].getListModel()
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
            destinationVC.list_index = lists.count
        } else if (segue.identifier == "list_to_items"){
            let destinationVC = segue.destination as! ListViewController
            destinationVC.list_index = selected_index
//            destinationVC.status_delegate = self
            destinationVC.list_id = selected_list!.id
        } else if (segue.identifier == "list_to_edit"){
            let destinationVC = segue.destination as! ListEditViewController
//            destinationVC.delegate = self
            destinationVC.list_index = selected_index
//            destinationVC.list = selected_list
        }
    }
    
    func addNewList(_ list: ListModel) {
        listHandler.insert(list_data: ["name": list.name,"index": String(list.index),"store_type_id": "1"])
//        self.lists.insert(list,at: 0)
//        addToLists(list: list, new: true)
        
        self.listsTableView.reloadData()
    }
    
    func deleteList(){
        let deleted_id: String  = String(lists[selected_index].id)
        let index: String = String(lists[selected_index].index)
        
        try! realm.write() {
            realm.delete(lists[selected_index])
        }

        listsTableView.deleteRows(at: [ IndexPath(row: selected_index, section: 0)], with: .fade)
        listHandler.delete(list_data: ["list_id":deleted_id ,"index": index ])
    }
    
    func updateListStatus(index: Int, status: ListStatus) {
        lists[index].status = status.rawValue
        listsTableView.reloadData()
    }
    
    func updatePrice(index: Int, total_price: Double) {
        lists[index].total_price = total_price
        listsTableView.reloadData()
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Lists Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ListsViewController {
    func addUpdateList(list: ListModel){
        
        let listItem = realm.objects(ListHistory.self).filter("index = \(list.index)").first
        
        try! realm.write() {
            if listItem == nil {
                realm.add(list.getRealmObject())
            } else {
                listItem!.id = list.id
                listItem!.name = list.name
                listItem!.total_price = list.total_price
                
                if list.old_total_price != nil {
                    listItem!.old_total_price = list.old_total_price!
                }
                 
            }
        }
    }
}
