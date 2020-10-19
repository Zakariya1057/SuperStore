//
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

protocol PriceChangeDelegate {
    func productChanged(_ product: ListItemModel)
    func productRemove(_ product: ListItemModel)
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PriceChangeDelegate, ListItemsDelegate {

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet var oldPriceView: UIView!
    @IBOutlet var oldPriceLabel: UILabel!
    
    var listHandler = ListItemsHandler()
    
    var identifier: String?
    
    let realm = try! Realm()
    
    var delegate:PriceChangeDelegate?
    
    var listItem: ListHistory? {
        return realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
    }
    
    var list: ListModel? {
        return listItem?.getListModel()
    }
    
    var status: ListStatus?
    
    var totalPrice: Double = 0
    
    @IBOutlet weak var listTableView: UITableView!

    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    var selected_row: Int = 0
    var selected_section: Int = 0
    
    var list_id: Int?
    
    var items:[ListItemModel] {
        return self.listItem?.getListModel().categories.flatMap { $0.items } ?? []
    }
    
    var refreshControl = UIRefreshControl()
    
    var loading: Bool = true
    
    var notificationToken: NotificationToken?
    
    var listManager: ListManager = ListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.Sections.ListHeader.SectionNibName, bundle: nil)
        self.listTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.ListHeader.SectionIdentifier)
        
        self.listTableView.register(UINib(nibName: K.Cells.ListItemCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListItemCell.CellIdentifier)
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        showTotalPrice()
        
        listHandler.delegate = self
        listHandler.request(listId:list_id!)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        listTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        let results = realm.objects(ListItemHistory.self)

        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial:
                    print("List Change. Initial")
                    self?.updateListInfo()
                    break
            case .update(_, _, _, _):
                    print("List Change. Update")
                    self?.listTableView.reloadData()
                    break
                case .error(let error):
                    fatalError("\(error)")
            }
        }
        
        if listItem != nil {
            configureUI()
        }
        
    }
    

    func contentLoaded(list: ListModel) {
        addToHistory(list)
        configureUI()
    }
    
    func configureUI(){
        self.title = list!.name
        self.list_id = list!.id
        self.status = list!.status
        
        showTotalPrice()
        
        self.listTableView.reloadData()
        stopLoading()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        listTableView.reloadData()
        refreshControl.endRefreshing()
        showError(message)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        listHandler.request(listId:list_id!)
    }
    
    func stopLoading(){
        loading = false
        listTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "List Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

//MARK: - Events, Navigation
extension ListViewController {
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "searchViewController"))! as! SearchViewController
//        destinationVC.delegate = self
        destinationVC.selectedListId = self.list_id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list_item_details" {
            let destinationVC = segue.destination as! ListItemViewController
            destinationVC.selected_row = selected_row
            destinationVC.selected_section = selected_section

            destinationVC.delegate = self
//            destinationVC.groceryDelegate = self
            destinationVC.product = list!.categories[selected_section].items[selected_row]
        }
    }
    
}

//MARK: - TableView
extension ListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if loading != true {
            return list?.categories.count ?? 0
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if loading == true {
            return
        }
        
        selected_row = indexPath.row
        selected_section = indexPath.section
        self.performSegue(withIdentifier: "list_item_details", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeItem(section: indexPath.section, row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = listTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.ListHeader.SectionIdentifier) as! ListSectionHeader
        
        if loading == true {
            header.headingLabel.text = ""
        } else {
            let section_item = list!.categories[section]
            let title = section_item.name
            let subtitle = section_item.aisle_name ?? ""

            header.headingLabel.text = title
            header.subHeadingLabel.text = subtitle
        }

        return header
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading != true {
            return list?.categories[section].items.count ?? 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListItemCell.CellIdentifier , for: indexPath) as! ListItemTableViewCell
        
        if loading != true {
            cell.product = list!.categories[indexPath.section].items[indexPath.row]
            cell.productIndex = indexPath.row
            cell.delegate = self
            
            cell.configureUI()
        } else {
            cell.startLoading()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
}

//MARK: - History Management
extension ListViewController {
    func addToHistory(_ list: ListModel){
        let item = realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
        
        if item != nil {
            try? realm.write(withoutNotifying: [notificationToken!], {
                
                realm.delete( realm.objects(ListItemHistory.self).filter("list_id = \(list_id!)") )
                realm.delete( realm.objects(ListCategoryHistory.self).filter("list_id = \(list_id!)") )
                
                for category in list.categories {
                    listItem?.categories.append(category.getRealmObject())
                }
            
            })
        } else {
            try? realm.write(withoutNotifying: [notificationToken!], {
                realm.add(list.getRealmObject())
            })
        }
    }
    
    func updateListInfo(){
        
        print("Update List Info")
        
        let item = realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
        
        if item != nil {
            print("Updating Details")
            try? realm.write(withoutNotifying: [notificationToken!], {
                
                showTotalPrice()
                
                print("Saving Changes")
                item!.status = list!.status.rawValue
                item!.totalPrice = totalPrice
                
                self.listTableView.reloadData()
            })
        } else {
            print("No List Found. Ignoring")
        }
        
    }
    
    func productRemove(_ product: ListItemModel) {
        try? realm.write(withoutNotifying: [notificationToken!], {
            realm.delete(realm.objects(ListItemHistory.self).filter("product_id = \(product.product_id) AND list_id = \(list_id!)"))
        })
        
        updateListInfo()
    }
    
    func productChanged(_ product: ListItemModel) {
  
        let data:[String: String] = [
            "product_id": String(product.product_id),
            "quantity": String(product.quantity),
            "ticked_off": String(product.ticked_off)
        ]

        listHandler.update(listId: list_id!, listData: data)
        
        try? realm.write(withoutNotifying: [notificationToken!], {
            let productItem = realm.objects(ListItemHistory.self).filter("product_id = \(product.product_id) AND list_id = \(list_id!)").first
            print("\(product.name): \(product.quantity). Ticked: \(product.ticked_off)")
            productItem!.ticked_off = product.ticked_off
            productItem!.quantity = product.quantity
            productItem!.totalPrice = product.totalPrice
        })
        
        updateListInfo()
        
        showTotalPrice()

    }
    
}

//MARK: - Calculations And Checks
extension ListViewController {
    
    func completedCheck(){
        //Check if all products completed. If the case then update the parent
        var checkedItems = 0
        var allItems = 0
        
        for item in items {
            
            allItems += 1
            
            if item.ticked_off == true {
                checkedItems += 1
            }
        }
        
        status = .notStarted
        
        if (allItems > 0){
           if(checkedItems == allItems){
               status = .completed
           } else if checkedItems > 0 {
               status = .inProgress
           }
        }
        
    }
    
    func showTotalPrice(){
        var price:Double = 0.00
        var priceNoPromotion: Double = 0.00
        var oldPrice: Double = 0.00
        
        let products = (list?.categories ?? []).map({ $0.items }).joined()

        var promotions = [Int: Dictionary<String, [Any]>]()
        
        for product in products {
            
            if product.promotion != nil {
                
                if let _ = promotions[product.promotion!.id] {
                    promotions[product.promotion!.id]!["products"]!.append(product)
                } else {
                    promotions[product.promotion!.id] = ["products": [product], "promotion": [product.promotion!]]
                }
                
            }
            
            price += listManager.calculateProductPrice(product)
            priceNoPromotion += ( Double(product.quantity) * product.price)
        }
        
        for promotion in promotions {
            let products = promotion.value["products"] as! [ListItemModel]
            let productCount = products.count
            let promotion = promotion.value["promotion"]![0] as! PromotionModel
            var newTotalPrice:Double = 0
            
            if productCount >= promotion.quantity {
                
                var highestPrice: Double = 0
                var previousTotalPrice: Double = 0
                var totalQuantity = 0
                
                for product in products {
                    previousTotalPrice = previousTotalPrice + listManager.calculateProductPrice(product)
                    totalQuantity = totalQuantity + product.quantity
                    
                    if product.price > highestPrice {
                        highestPrice = product.price
                    }
                }
                
                let remainder = (totalQuantity % promotion.quantity)
                let goesIntoFully = floor(Double(totalQuantity) / Double(promotion.quantity))
                
                var newTotal: Double = 0
                
                if promotion.forQuantity != nil && promotion.forQuantity! > 0 {
                    newTotal = (Double(goesIntoFully) * (Double(promotion.forQuantity!) * highestPrice) ) + (Double(remainder) * highestPrice)
                } else if (promotion.price != nil && promotion.price! > 0){
                    newTotal = (Double(goesIntoFully) * promotion.price!) + (Double(remainder) * highestPrice)
                }
                
                newTotalPrice = (price - previousTotalPrice) + newTotal
                
                if newTotalPrice != price && price > newTotalPrice {
                    oldPrice = priceNoPromotion
                    price = newTotalPrice
                }
                
            }
            
        }
        
        if oldPrice != 0 {
            oldPriceView.alpha = 1
            oldPriceLabel.text = "£" + String(format: "%.2f", oldPrice )
        } else {
            oldPriceView.alpha = 0
        }
        
        self.totalPriceLabel.text = "£" + String(format: "%.2f", price)
        self.totalPrice = price
        
    }
}

//MARK: - Shared Functionality
extension ListViewController {
    
    func removeItem(section: Int, row: Int){

        let product = list!.categories[section].items[row]
        
        let indexPath = IndexPath(row: row, section: section)
        let indexSet = NSIndexSet(index: section)
        
        if list!.categories[section].items.count == 1 {
            
            try? realm.write(withoutNotifying: [notificationToken!], {
                let deleteCategory = realm.objects(ListCategoryHistory.self).filter("list_id = \(list_id!) AND id=\(list!.categories[section].id)").first
                realm.delete(deleteCategory!.items)
                realm.delete(deleteCategory!)
            })

            listTableView.deleteSections(indexSet as IndexSet, with: .fade)
        } else {
            try? realm.write(withoutNotifying: [notificationToken!], {
                let deleteItem = list!.categories[section].items[row]
                realm.delete( realm.objects(ListItemHistory.self).filter("list_id = \(list_id!) AND product_id=\(deleteItem.product_id)") )
            })
            
            listTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        listHandler.delete(list_id: list_id!, list_data: ["product_id": String(product.product_id)])
        
        showTotalPrice()
    }
    
}
