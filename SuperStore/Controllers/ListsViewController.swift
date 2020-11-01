//
//  ListsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class ListsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ListDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var listsTableView: UITableView!
    
    var userHandler = UserHandler()
    
    var listHandler = ListsHandler()
    var listItemHandler = ListItemsHandler()
    
    var listManager: ListManager = ListManager()
    
    let realm = try! Realm()
    lazy var lists: Results<ListHistory> = {
        return self.realm.objects(ListHistory.self).filter("deleted = false").sorted(byKeyPath: "created_at", ascending: false)
    }()
    
    var selectedList: ListModel?
    var selectedIndex: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    var delegate: ListSelectedDelegate?
    
    var loading: Bool = true
    let loadingCell: Int = 1
    
    var notificationToken: NotificationToken?
    
    var searchText: String = ""
    
    var offline: Bool {
        return RequestHandler.sharedInstance.offline
    }
    
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
        
        if lists.count > 0 || offline {
            loading = false
            listsTableView.reloadData()
        }
        
    }
    
    func contentLoaded(lists: [ListModel]) {
        print("Content Loaded")
        addUpdateLists(lists)
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
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
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
            self.deleteList(identifier: self.lists[self.selectedIndex].identifier)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if loading {
            return
        }
        
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
    
    
    
    func deleteList(identifier: String){
        
        let listItem = realm.objects(ListHistory.self).filter("identifier = %@", identifier).first
        
        if listItem == nil {
            return print("List Not Found")
        }
        
        let listId = listItem!.id
        
        try? realm.write(withoutNotifying: [notificationToken!], {
            realm.delete(realm.objects(ListItemHistory.self).filter("list_id = %@", listItem!.id))
            
            if  listItem!.synced && offline {
                listItem!.deleted = true
            } else {
                realm.delete(listItem!)
            }
        })
        
        listsTableView.deleteRows(at: [ IndexPath(row: selectedIndex, section: 0)], with: .fade)
        listHandler.delete(list_data: ["list_id": String(listId) ,"identifier": identifier ])
        
    }
    
    func updateListStatus(index: Int, status: ListStatus) {
        listsTableView.reloadData()
    }
    
    func updatePrice(index: Int, total_price: Double) {
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
    func addUpdateLists(_ lists: [ListModel]){
        
        print("Add update list")
        
        // For all lists we received, if found then update, if not then create.
        // For list item not mentioned due to not being synced send to backend.
        var foundListIdentifiers: [String: Int] = [:]
        
        for list in lists {
            let listHistory = realm.objects(ListHistory.self).filter("identifier = %@", list.identifier).first
            
            try? realm.write(withoutNotifying: [notificationToken!], {
                
                if listHistory == nil {
                    realm.add(list.getRealmObject())
                } else {
                    
                    if listHistory!.deleted {
                        realm.delete(listHistory!)
                        listHandler.delete(list_data: ["list_id": String(list.id) ,"identifier": list.identifier ])
                    } else {
                        
                        if listHistory!.edited {
                            listManager.uploadEditedList(listHistory: listHistory!)
                        } else {
                            
                            listHistory!.id = list.id
                            listHistory!.name = list.name
                            listHistory!.totalPrice = list.totalPrice
                            
                            if list.old_total_price != nil {
                                listHistory!.old_total_price = list.old_total_price!
                            }
                            
                        }
                        
                        foundListIdentifiers[list.identifier] = list.id
                        
                        // If list create in offline, sync here
                        if listHistory!.synced == false {
                            
                            listHistory!.synced = true
                            
                            // Syncing List Items. Works for adding new items. Not deleted items
                            for category in listHistory!.categories {
                                
                                for product in category.items {
                                    let data:[String: String] = [
                                        "product_id": String(product.product_id),
                                        "quantity": String(product.quantity),
                                        "ticked_off": String(product.ticked_off)
                                    ]
                                    
                                    listItemHandler.create(list_id: listHistory!.id, list_data: data)
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
        let listsHistory = realm.objects(ListHistory.self)
        for list in listsHistory {
            if foundListIdentifiers[list.identifier] == nil {
                // Uploading new offline list
                if list.synced == false {
                    print("Unsynced list, created in offline. Sent to endpoint.")
                    listHandler.insert(list_data: ["name": list.name,"identifier": list.identifier,"store_type_id": "1"])
                } else {
                    // Delete offline deleted list
                    try? realm.write(withoutNotifying: [notificationToken!], {
                        realm.delete(realm.objects(ListItemHistory.self).filter("list_id = %@",lists[selectedIndex].id ))
                        realm.delete(list)
                    })
                    
                }
            }
        }
        
    }
    
//
//    func uploadEditedList(listHistory: ListHistory){
//        // List edited:
//        // Update name
//        // Update/Insert All Items
//
//        var items:[[String: String]] = []
//
//        for category in listHistory.categories {
//
//            for product in category.items {
//
//                items.append([
//                    "product_id": String(product.product_id),
//                    "quantity": String(product.quantity),
//                    "ticked_off": String(product.ticked_off)
//                ])
//
//            }
//
//        }
//
//        listHandler.update(list_data: [
//            "identifier": listHistory.identifier,
//            "name": listHistory.name,
//            "store_type_id": "1",
//            "items": items
//        ])
//
//        listHistory.edited = false
//    }
//
//    func configureItems(listId: Int){
//        // Will only run in online mode.
//
//        // Get all soft deleted items, delete them for real
//        let deletedItems = realm.objects(ListItemHistory.self).filter("list_id = \(listId) and deleted = true")
//        for item in deletedItems {
//            listItemHandler.delete(list_id: listId, list_data: ["product_id": String(item.product_id)])
//            realm.delete(item)
//        }
//
//        var foundListItems: [Int: String] = [:]
//
//        // Get all edited items show their changes
//        let editedItems = realm.objects(ListItemHistory.self).filter("list_id = \(listId) and edited = true")
//        for item in editedItems {
//            foundListItems[item.product_id] = item.name
//
//            let data:[String: String] = [
//                "product_id": String(item.product_id),
//                "quantity": String(item.quantity),
//                "ticked_off": String(item.ticked_off)
//            ]
//
//
//            listItemHandler.update(listId: listId, listData: data)
//        }
//
//        // Get all new items, send them to backend
//        let newItems = realm.objects(ListItemHistory.self).filter("list_id = \(listId) and synced = false")
//        for item in newItems {
//
//            if foundListItems[item.product_id] == nil {
//                foundListItems[item.product_id] = item.name
//                listItemHandler.create(list_id: listId, list_data: ["product_id": String(item.product_id)])
//            }
//
//        }
//
//    }

    
}
