////
////  SuperStore
////
////  Created by Zakariya Mohummed on 30/07/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//protocol PriceChangeDelegate {
//    func productChanged(_ product: ListItemModel)
//    func productRemove(_ product: ListItemModel)
//}
//
//class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListItemsDelegate, PriceChangeDelegate {
//    
//    var listManager: ListManager = ListManager()
//    
//    @IBOutlet weak var totalPriceLabel: UILabel!
//    
//    @IBOutlet var oldPriceView: UIView!
//    @IBOutlet var oldPriceLabel: UILabel!
//    
//    var listHandler = ListItemsHandler()
//    
//    var identifier: String?
//    
//    let realm = try! Realm()
//    
//    var userHandler = UserHandler()
//    
//    var delegate: PriceChangeDelegate?
//    
//    var listItem: ListHistory? {
//        return realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
//    }
//    
//    var list: ListModel?
//    
//    var status: ListStatus?
//    
//    var totalPrice: Double = 0
//    
//    var tickedOffItems: Int = 0
//    
//    @IBOutlet weak var listTableView: UITableView!
//    
//    @IBOutlet weak var addCategoryButton: UIButton!
//    @IBOutlet weak var storeButton: UIButton!
//    
//    var selected_row: Int = 0
//    var selected_section: Int = 0
//    
//    var listID: Int?
//    
//    var totalItems: Int {
//        return items.count
//    }
//    
//    var items:[ListItemModel] {
//        return self.listItem?.getListModel().categories.flatMap { $0.items } ?? []
//    }
//    
//    var offline: Bool {
//        return RequestHandler.sharedInstance.offline
//    }
//    
//    var refreshControl = UIRefreshControl()
//    
//    var loading: Bool = true
//    
//    var notificationToken: NotificationToken?
////    var listNotificationToken: NotificationToken?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let nib = UINib(nibName: K.Sections.ListHeader.SectionNibName, bundle: nil)
//        self.listTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.ListHeader.SectionIdentifier)
//        
//        self.listTableView.register(UINib(nibName: K.Cells.ListItemCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListItemCell.CellIdentifier)
//        
//        self.listTableView.delegate = self
//        self.listTableView.dataSource = self
//        
//        showTotalPrice()
//        
//        listHandler.delegate = self
//        listHandler.request(listID:listID!)
//        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        listTableView.addSubview(refreshControl) // not required when using UITableViewController
//        
//        configureObserver()
//        
//        if listItem != nil {
//            
//            self.title = listItem!.name
//            
//            self.tickedOffItems = listItem!.tickedOffItems
//            self.status = ListStatus(rawValue: listItem!.status)
//            self.totalPrice = listItem!.totalPrice
//            
//            if RequestHandler.sharedInstance.offline == true {
//                if listItem!.totalItems > 0 && listItem!.categories.count == 0 {
//                    // Grocery list items not downloaded. Show error message. Connection Required To Load List.
//                    return showError("Internet connection required to load list")
//                } else if listItem!.categories.count > 0 {
//                    self.list = listItem?.getListModel()
//                    configureUI()
//                }
//            }
//            
//            if listItem!.edited {
//                try? realm.write(withoutNotifying: [notificationToken!], {
//                    listManager.uploadEditedList(listHistory: listItem!)
//                    print("List has been edited in offline mode. Upload changes before clearing list")
//                })
//            }
//            
//        }
//        
//    }
//    
//    func contentLoaded(list: ListModel) {
//        print("Content Loaded")
//        addToHistory(list)
//        configureUI()
//    }
//    
//    func errorHandler(_ message: String) {
//        loading = false
//        listTableView.reloadData()
//        refreshControl.endRefreshing()
//        showError(message)
//    }
//    
//    func logOutUser(){
//        userHandler.userSession.viewController = self
//        userHandler.requestLogout()
//    }
//    
//    func configureUI(){
//        self.title = list!.name
//        self.listID = list!.id
//        self.status = list!.status
//        
//        showTotalPrice()
//        
//        self.listTableView.reloadData()
//        stopLoading()
//    }
//
//    @objc func refresh(_ sender: AnyObject) {
//        if !offline {
//            print("Online. Request")
//            
//            if listItem!.edited {
//                try? realm.write(withoutNotifying: [notificationToken!], {
//                    listManager.uploadEditedList(listHistory: listItem!)
//                    print("List has been edited in offline mode. Upload changes before clearing list")
//                    refreshControl.endRefreshing()
//                })
//                
//            } else {
//                listHandler.request(listID:listID!)
//            }
//
//        } else {
//            print("Offline. Ignore")
//            refreshControl.endRefreshing()
//        }
//    }
//    
//    func stopLoading(){
//        loading = false
//        listTableView.reloadData()
//        refreshControl.endRefreshing()
//    }
//    
//    deinit {
//        notificationToken?.invalidate()
//    }
//    
//    func showError(_ error: String){
//        let alert = UIAlertController(title: "List Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//    
//}
//
////MARK: - Events, Navigation
//extension ListViewController {
//    
//    @IBAction func addButtonPressed(_ sender: Any) {
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "searchViewController"))! as! SearchViewController
//        destinationVC.selectedListID = self.listID
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "list_item_details" {
//            let destinationVC = segue.destination as! ListItemViewController
//            destinationVC.listItem = list!.categories[selected_section].items[selected_row]
//            destinationVC.parentCategoryId = list!.categories[selected_section].id
//        }
//    }
//    
//}
//
////MARK: - TableView
//extension ListViewController {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if loading != true {
//            return list?.categories.count ?? 0
//        } else {
//            return 1
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if loading == true {
//            return
//        }
//        
//        selected_row = indexPath.row
//        selected_section = indexPath.section
//        self.performSegue(withIdentifier: "list_item_details", sender: nil)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.removeItem(section: indexPath.section, row: indexPath.row)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let header = listTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.ListHeader.SectionIdentifier) as! ListSectionHeader
//        
//        if loading == true {
//            header.headingLabel.text = ""
//        } else {
//            let section_item = list!.categories[section]
//            let title = section_item.name
//            let subtitle = section_item.aisleName ?? ""
//            
//            header.headingLabel.text = title
//            header.subHeadingLabel.text = subtitle
//        }
//        
//        return header
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if loading != true {
//            return list?.categories[section].items.count ?? 0
//        } else {
//            return 5
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListItemCell.CellIdentifier , for: indexPath) as! ListItemTableViewCell
//        
//        if loading != true {
//            cell.product = list!.categories[indexPath.section].items[indexPath.row]
//            cell.delegate = self
//            
//            cell.configureUI()
//        } else {
//            cell.startLoading()
//        }
//        
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        
//        return cell
//    }
//    
//}
//
////MARK: - History Management
//extension ListViewController {
//    
//    func configureObserver(){
//        let results = realm.objects(ListItemHistory.self)
//        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//            case .initial:
//                print("List Change. Initial")
//                self?.completedCheck()
//                self?.updateListInfo()
//                break
//            case .update(_, _, _, _):
//                print("List Change. Update")
//                self?.completedCheck()
//                self?.updateListInfo()
//                self?.listTableView.reloadData()
//                break
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//    }
//    
//    
//    func addToHistory(_ list: ListModel){
//        let item = realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
//        
//        // if list has been edited in offline mode. Upload changes before clearing list
//        if item != nil {
//
//            try? realm.write(withoutNotifying: [notificationToken!], {
//                realm.delete( realm.objects(ListItemHistory.self).filter("listID = \(listID!)") )
//                realm.delete( realm.objects(ListCategoryHistory.self).filter("listID = \(listID!)") )
//                
//                for category in list.categories {
//                    listItem?.categories.append(category.getRealmObject())
//                }
//                
//            })
//
//        } else {
//            try? realm.write(withoutNotifying: [notificationToken!], {
//                realm.add(list.getRealmObject())
//            })
//        }
//        
//        self.list = listItem?.getListModel()
//    
//    }
//    
//    func updateListInfo(){
//        
//        if realm.isInWriteTransaction || loading {
//            return
//        }
//        
//        let listHistory = realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
//        
//        if listHistory != nil {
//            try? realm.write(withoutNotifying: [notificationToken!], {
//
//                showTotalPrice()
//
//                print("Saving Changes")
//                print("Set Total Price: \(self.totalPrice)")
//                
//                self.list = listItem?.getListModel()
//                
//                listHistory!.status = status!.rawValue
//                listHistory!.totalPrice = totalPrice
//                
//                if offline {
//                    listHistory!.edited = true
//                }
//
//                listHistory!.tickedOffItems = tickedOffItems
//                
//                if !(totalItems == 0 && listHistory!.totalItems != 0){
//                    listHistory!.totalItems = totalItems
//                }
//                
//                listHistory!.updatedAt = Date()
//            })
//        } else {
//            print("No List Found. Ignoring")
//        }
//        
//    }
//    
//    func productRemove(_ product: ListItemModel) {
//        try? realm.write(withoutNotifying:[notificationToken!], {
//            realm.delete(realm.objects(ListItemHistory.self).filter("productID = \(product.productID) AND listID = \(listID!)"))
//        })
//        
//        listHandler.delete(listID: listID!, listData: ["product_id": String(product.productID)])
//        updateListInfo()
//    }
//    
//    func productChanged(_ product: ListItemModel) {
//
//        listEdited()
//        
//        let data:[String: String] = [
//            "product_id": String(product.productID),
//            "quantity": String(product.quantity),
//            "ticked_off": String(product.tickedOff)
//        ]
//
//        listHandler.update(listID: listID!, listData: data)
//
//        completedCheck()
//        
//        try? realm.write(withoutNotifying: [notificationToken!], {
//            let productItem = realm.objects(ListItemHistory.self).filter("productID = \(product.productID) AND listID = \(listID!)").first
//            productItem!.tickedOff = product.tickedOff
//            productItem!.quantity = product.quantity
//            productItem!.totalPrice = product.totalPrice
//            
//            listItem?.totalItems = self.totalItems
//            listItem?.tickedOffItems = self.tickedOffItems
//            listItem?.status = self.status!.rawValue
//        })
//
//    }
//
//}
//
////MARK: - Calculations And Checks
//extension ListViewController {
//    
//    func completedCheck(){
//        // Check if all products completed. If the case then update the parent
//        
//        if !userHandler.userSession.isLoggedIn() {
//            notificationToken?.invalidate()
//            return
//        }
//        
//        if loading {
//            return
//        }
//        
//        var checkedItems = 0
//        var allItems = 0
//        
//        for item in items {
//            
//            allItems += 1
//            
//            if item.tickedOff == true {
//                checkedItems += 1
//            }
//        }
//        
//        status = .notStarted
//        
//        if (allItems > 0){
//            if(checkedItems == allItems){
//                status = .completed
//            } else if checkedItems > 0 {
//                status = .inProgress
//            }
//        }
//        
//        self.tickedOffItems = checkedItems
//       
//    }
//    
//    func showTotalPrice(){
//        
//        var price:Double = 0.00
//        var priceNoPromotion: Double = 0.00
//        var oldPrice: Double = 0.00
//        
//        let products = (listItem?.getListModel().categories ?? []).map({ $0.items }).joined()
//        
//        var promotions = [Int: Dictionary<String, [Any]>]()
//        
//        for product in products {
//            
//            if product.promotion != nil {
//                if let _ = promotions[product.promotion!.id] {
//                    promotions[product.promotion!.id]!["products"]!.append(product)
//                } else {
//                    promotions[product.promotion!.id] = ["products": [product], "promotion": [product.promotion!]]
//                }
//            }
//            
//            price += listManager.calculateProductPrice(product)
//            priceNoPromotion += ( Double(product.quantity) * product.price)
//        }
//        
//        for promotion in promotions {
//            let products = promotion.value["products"] as! [ListItemModel]
//            let promotion = promotion.value["promotion"]![0] as! PromotionModel
//            var newTotalPrice: Double = 0
//            
//            var totalQuantity = 0
//            
//            for product in products {
//                totalQuantity += product.quantity
//            }
//            
//            print("Total Quantity: \(totalQuantity)")
//            
//            if totalQuantity >= promotion.quantity {
//                
//                var highestPrice: Double = 0
//                var previousTotalPrice: Double = 0
//                
//                for product in products {
//                    previousTotalPrice = previousTotalPrice + listManager.calculateProductPrice(product)
//                    
//                    if product.price > highestPrice {
//                        highestPrice = product.price
//                    }
//                }
//                
//                let remainder = (totalQuantity % promotion.quantity)
//                let goesIntoFully = floor(Double(totalQuantity) / Double(promotion.quantity))
//                
//                var newTotal: Double = 0
//                
//                if promotion.forQuantity != nil && promotion.forQuantity! > 0 {
//                    newTotal = (Double(goesIntoFully) * (Double(promotion.forQuantity!) * highestPrice) ) + (Double(remainder) * highestPrice)
//                } else if (promotion.price != nil && promotion.price! > 0){
//                    newTotal = (Double(goesIntoFully) * promotion.price!) + (Double(remainder) * highestPrice)
//                }
//                
//                newTotalPrice = (price - previousTotalPrice) + newTotal
//                
//                if newTotalPrice != price && price > newTotalPrice {
//                    oldPrice = priceNoPromotion
//                    price = newTotalPrice
//                }
//                
//            }
//            
//        }
//        
//        if oldPrice != 0 {
//            oldPriceView.alpha = 1
//            oldPriceLabel.text = "£" + String(format: "%.2f", oldPrice )
//        } else {
//            oldPriceView.alpha = 0
//        }
//        
//        self.totalPriceLabel.text = "£" + String(format: "%.2f", price)
//        self.totalPrice = price
//        
//    }
//}
//
////MARK: - Shared Functionality
//extension ListViewController {
//    
//    func listEdited(){
//        try? realm.write(withoutNotifying: [notificationToken!], {
//            if offline {
//                listItem?.edited = true
//            }
//        })
//    }
//    
//    func removeItem(section: Int, row: Int){
//        
//        let product = list!.categories[section].items[row]
//        
//        let indexPath = IndexPath(row: row, section: section)
//        let indexSet = NSIndexSet(index: section)
//        
//        listEdited()
//        
//        try? realm.write(withoutNotifying: [notificationToken!], {
//           
//            if list!.categories[section].items.count == 1 {
//                let deleteCategory = realm.objects(ListCategoryHistory.self).filter("listID = \(listID!) AND id=\(list!.categories[section].id)").first
//                realm.delete(deleteCategory!.items)
//                realm.delete(deleteCategory!)
//                
//                self.list = listItem?.getListModel()
//                
//                listTableView.deleteSections(indexSet as IndexSet, with: .fade)
//            } else {
//                let item = list!.categories[section].items[row]
//                let deleteItem = realm.objects(ListItemHistory.self).filter("listID = \(listID!) AND productID = \(item.productID)").first
//                realm.delete( deleteItem! )
//                
//                self.list = listItem?.getListModel()
//                
//                listTableView.deleteRows(at: [indexPath], with: .fade)
//            }
//            
//            listHandler.delete(listID: listID!, listData: ["product_id": String(product.productID)])
//            
//            showTotalPrice()
//        })
//
//    }
//    
//}