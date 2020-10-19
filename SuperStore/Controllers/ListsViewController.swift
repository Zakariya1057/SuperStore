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

class ListsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,NewListDelegate, ListDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var listsTableView: UITableView!
    
    var listHandler = ListsHandler()
    
    let realm = try! Realm()
    lazy var lists: Results<ListHistory> = {
        return self.realm.objects(ListHistory.self).sorted(byKeyPath: "created_at", ascending: false)
    }()

    var selectedList: ListModel?
    var selectedIndex: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    var delegate: ListSelectedDelegate?
    
    var loading: Bool = true
    let loadingCell: Int = 1
    
    var notificationToken: NotificationToken?

    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        listsTableView.register(UINib(nibName: K.Cells.ListCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListCell.CellIdentifier)
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
        
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
                    break
            case .update(_, _, _, _):
                    self?.listsTableView.reloadData()
                    break
                case .error(let error):
                    fatalError("\(error)")
            }
        }
        
        if delegate != nil {
          self.navigationItem.rightBarButtonItem = nil
        }
        
        if lists.count > 0{
            loading = false
            listsTableView.reloadData()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        listsTableView.reloadData()
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
        if searchText != "" {
            return search().count
        } else {
            return loading ? loadingCell : lists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListCell.CellIdentifier , for: indexPath) as! ListsTableViewCell
        
        if !loading {
            if searchText != "" {
                cell.list = search()[indexPath.row].getListModel()
            } else {
                cell.list = lists[indexPath.row].getListModel()
            }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.loading = loading
        cell.configureUI()
        
        return cell
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Deleting List?", message: "Are you sure you want to delete this list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.deleteList()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lists.indices.contains(indexPath.row) {
            
            if searchText != "" {
                selectedList = search()[indexPath.row].getListModel()
            } else {
                selectedList = lists[indexPath.row].getListModel()
            }
            
            selectedIndex = indexPath.row
            
            if delegate != nil {
                self.delegate?.listSelected(list_id: selectedList!.id)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "list_to_items", sender: self)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
            if searchText != "" {
                selectedList = search()[indexPath.row].getListModel()
            } else {
                selectedList = lists[indexPath.row].getListModel()
            }
        
            selectedIndex = indexPath.row
                
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
            destinationVC.listIndex = lists.count
        } else if (segue.identifier == "list_to_items"){
            let destinationVC = segue.destination as! ListViewController
            destinationVC.identifier = lists[selectedIndex].identifier
            destinationVC.list_id = selectedList!.id
        } else if (segue.identifier == "list_to_edit"){
            let destinationVC = segue.destination as! ListEditViewController
            destinationVC.identifier = lists[selectedIndex].identifier
        }
    }
    
    func addNewList(_ list: ListModel) {
        listHandler.insert(list_data: ["name": list.name,"identifier": list.identifier,"store_type_id": "1"])
        self.listsTableView.reloadData()
    }
    
    func deleteList(){
        let deleted_id: String  = String(lists[selectedIndex].id)
        let identifier: String = lists[selectedIndex].identifier
        
        try! realm.write() {
            realm.delete(lists[selectedIndex])
        }

        listsTableView.deleteRows(at: [ IndexPath(row: selectedIndex, section: 0)], with: .fade)
        listHandler.delete(list_data: ["list_id":deleted_id ,"identifier": identifier ])
    }
    
    func updateListStatus(index: Int, status: ListStatus) {
//        lists[index].status = status.rawValue
        listsTableView.reloadData()
    }
    
    func updatePrice(index: Int, total_price: Double) {
//        lists[index].totalPrice = total_price
        listsTableView.reloadData()
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Lists Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func search() -> Results<ListHistory> {
        return self.realm.objects(ListHistory.self).filter("name CONTAINS[c] %@", searchText).sorted(byKeyPath: "created_at", ascending: false)
    }
}

extension ListsViewController {
    func addUpdateList(list: ListModel){
        
        let listItem = realm.objects(ListHistory.self).filter("identifier = %@", list.identifier).first
        
        try! realm.write() {
            if listItem == nil {
                realm.add(list.getRealmObject())
            } else {
                listItem!.id = list.id
                listItem!.name = list.name
                listItem!.totalPrice = list.totalPrice
                
                if list.old_total_price != nil {
                    listItem!.old_total_price = list.old_total_price!
                }
                 
            }
        }
    }
}
