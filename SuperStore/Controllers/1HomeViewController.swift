////
////  HomeViewController.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 22/07/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
import UIKit
import Kingfisher
import RealmSwift
import NotificationBannerSwift
//
//class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ShowListDelegate, ProductDelegate, ScrollCollectionDelegate, OfferSelectedDelegate, HomeRequestDelegate, StoreSelectedDelegate, ListProgressDelegate, UserLocationDeniedDelegate, UITabBarControllerDelegate {
//
//    @IBOutlet weak var listTableView: UITableView!
//    
//    var customElements: [CustomElementModel] = []
//    
//    var refreshControl = UIRefreshControl()
//    
//    var scrollPositions: [String: CGFloat] = [:]
//    
//    var homeHandler = HomeHandler()
//    
//    var listNotificationToken: NotificationToken?
//    var monitoredNotificationToken: NotificationToken?
//    
//    var loading: Bool = true
//    
//    let realm = try! Realm()
//    
//    var userHandler = UserHandler()
//    
//    var home: HomeHistory? {
//        return self.realm.objects(HomeHistory.self).first
//    }
//    
//    var listManager: ListManager = ListManager()
//    
//    var networkManager: NetworkManager = NetworkManager()
//    
//    var offline: Bool {
//        return RequestHandler.sharedInstance.offline
//    }
//
//    var loggedIn: Bool {
//        return userHandler.userSession.isLoggedIn()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        homeHandler.delegate = self
//        homeHandler.request()
//        
//        // Deletes all kingfisher cached images
////        KingfisherManager.shared.cache.clearMemoryCache()
////        KingfisherManager.shared.cache.clearDiskCache()
////        KingfisherManager.shared.cache.cleanExpiredDiskCache()
//        
//        createHomeSections()
//        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
//        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
//        listTableView.addSubview(refreshControl)
//        
////        listTableView.register(UINib(nibName: K.Cells.ListPriceUpdateCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListPriceUpdateCell.CellIdentifier)
//
//        listTableView.register(UINib(nibName: K.Cells.FeaturedProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.FeaturedProductCell.CellIdentifier)
//        
//        listTableView.register(UINib(nibName: K.Cells.OffersCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.OffersCell.CellIdentifier)
//        
//        listTableView.register(UINib(nibName: K.Cells.ListsProgressCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListsProgressCell.CellIdentifier)
//        
//        listTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
//        
//        listTableView.register(UINib(nibName: K.Cells.StoreMapCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoreMapCell.CellIdentifier)
//        
//        let nib = UINib(nibName: K.Sections.HomeHeader.SectionNibName, bundle: nil)
//        self.listTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.HomeHeader.SectionIdentifier)
//        
//        listTableView.dataSource = self
//        listTableView.delegate = self
//
//        if home != nil {
//            configureUI()
//        }
//        
//        monitorListChange()
//        monitoredChange()
//
//    }
//    
//    func contentLoaded(content: HomeModel) {
//        addToHistory(content)
//        configureUI()
//    }
//    
//    func configureUI(){
//        
//        self.loading = false
//        
//        configureNotifications()
//        
//        let content = home!.getHomeModel()
//            
//        createHomeSections()
//        
//        configureLists()
//        
//        for element in customElements {
//
//            switch element {
//                case is StoresMapElement:
//                    let storeElement = element as! StoresMapElement
//                    storeElement.stores = content.stores
//                    break
//                case is GroceryProductElement:
//                    let productElement = element as! GroceryProductElement
//                    productElement.products = content.groceries
//                    break
//                case is MonitoringProductElement:
//                    let productElement = element as! MonitoringProductElement
//                    productElement.products = content.monitoring.reversed()
//                    break
//                case is OffersElement:
//                    let offerElement = element as! OffersElement
//                    offerElement.promotions = content.promotions
//                    break
//                case is FeaturedProductElement:
//                    let featuredElement = element as! FeaturedProductElement
//                    featuredElement.products = content.featured
//                    break
//                default:
//                    print("Unknown Type Encountered: \(element.type)")
//            }
//        }
//        
//        for category in content.categories {
//            let name = category.key
//            let products = category.value
//            
//            let element = ProductElement(title: name,delegate: self, scrollDelegate: self, products: products)
//            customElements.append(element)
//        }
//        
//        listTableView.reloadData()
//        refreshControl.endRefreshing()
//    }
//    
//    func errorHandler(_ message: String) {
//        showError(message)
//    }
//    
//    func showError(_ error: String){
//        let alert = UIAlertController(title: "Home Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//    
//    func logOutUser(){
//        userHandler.userSession.viewController = self
//        userHandler.requestLogout()
//    }
//    
//    deinit {
//        listNotificationToken?.invalidate()
//        monitoredNotificationToken?.invalidate()
//    }
//    
//    @objc func refresh(){
//        // Code to refresh table view
//        if !offline {
//            self.loading = true
//            createHomeSections()
//            listTableView.reloadData()
//            homeHandler.request()
//        } else {
//            refreshControl.endRefreshing()
//        }
//    }
//
//}
//
//extension HomeViewController {
//    func configureNotifications(){
//        let banner = StatusBarNotificationBanner(title: "Offline Mode", style: .warning)
//        banner.autoDismiss = false
//        
//        networkManager.reachability.whenReachable = { [self] _ in
//            print("Network is available")
//            RequestHandler.sharedInstance.offline = false
//            banner.dismiss()
//            banner.alpha = 0
//            
//            // Lists changed offline, now back online. Sync with endpoint.
//            let editedLists = realm.objects(ListHistory.self).filter("edited = true OR deleted = true")
//            
//            try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                for editedList in editedLists {
//                    listManager.uploadEditedList(listHistory: editedList)
//                }
//            })
//            
//        }
//
//        networkManager.reachability.whenUnreachable = { _ in
//            print("Network is unavailable")
//            RequestHandler.sharedInstance.offline = true
//            banner.show()
//            banner.alpha = 1
//        }
//    }
//}
//
//extension HomeViewController {
//    
//    func configureLists(){
//
////        if !userHandler.userSession.isLoggedIn() {
////            listNotificationToken?.invalidate()
////            monitoredNotificationToken?.invalidate()
////            return
////        }
//        
//        if offline {
//            return print("Offline Mode")
//        } else {
//            print("Online Change List. Lists")
//        }
//        
//        var showingLists:[ListModel] = []
//        
//        if home != nil && loggedIn && customElements[0] is ListsProgressElement{
//            
//            let listElement = customElements[0] as! ListsProgressElement
//            
//            if home!.lists.count < 4 {
//                // No List On Page. Get Last 4 Recent. Show
//                let recentLists = realm.objects(ListHistory.self).filter("deleted = false").sorted(byKeyPath: "updatedAt", ascending: false)
//                
//                for index in 0...3 {
//                    if recentLists.indices.contains(index){
//                        showingLists.append(recentLists[index].getListModel())
//                    }
//
//                }
//                
//            } else {
//                showingLists = home!.getHomeModel().lists
//            }
//        
//            listElement.lists = showingLists
//            
//        }
//        
//    }
//    
//    func configureMonited(){
//        
////        if !userHandler.userSession.isLoggedIn() {
////            listNotificationToken?.invalidate()
////            monitoredNotificationToken?.invalidate()
////            return
////        }
//        
//        if realm.isInWriteTransaction || offline {
//            return print("Offline Mode/Transaction")
//        } else {
//            print("Online Change List. Monitor")
//        }
//        
//        print("Monitoring Change")
//        
//        if home != nil && loggedIn {
//            try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                let monitoringElement = customElements[3] as! ProductElement
//                monitoringElement.products = realm.objects(ProductHistory.self).filter("monitoring = true").map{ $0.getProductModel() }.reversed()
//            })
//        }
//        
//    }
//    
//    func addSectionProducts( _ products: [ProductModel], _ elementIndex:Int){
//        let productElement = customElements[elementIndex] as! ProductElement
//        productElement.products = products
//    }
//    
//}
//
//extension HomeViewController {
//    
//    func monitoredChange(){
//        let results = realm.objects(ProductHistory.self)
//        
//        monitoredNotificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//                case .initial:
//                    self?.configureMonited()
//                    self?.listTableView.reloadData()
//                    break
//            case .update(_, _, _, _):
//                    self?.configureMonited()
//                    self?.listTableView.reloadData()
//                    break
//                case .error(let error):
//                    fatalError("\(error)")
//            }
//        }
//    }
//    
//    func monitorListChange(){
//        let results = realm.objects(ListHistory.self)
//        
//        listNotificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//                case .initial:
//                    self?.configureLists()
//                    self?.listTableView.reloadData()
//                    break
//            case .update(_, _, _, _):
//                    self?.configureLists()
//                    self?.listTableView.reloadData()
//                    break
//                case .error(let error):
//                    fatalError("\(error)")
//            }
//        }
//        
//    }
//    
//}
//
//extension HomeViewController {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return customElements.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let title = customElements[section].title
//        let header = listTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.HomeHeader.SectionIdentifier) as! HomeSectionHeader
//        header.headingLabel.text = title
//        return header
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellModel = customElements[indexPath.section]
//        let cellIdentifier = cellModel.type.rawValue
//        let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomElementCell
//
//        cellModel.loading = self.loading
//        customCell.configure(withModel: cellModel)
//
//        let cell = customCell as! UITableViewCell
//
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        
//        return cell
//    }
//    
//}
//
//extension HomeViewController {
//    
//    func createHomeSections(){
//        
//        print("Update Home Sections")
//        
//        customElements = [
//            
////            ListPriceUpdateElement(title: "Grocery List Price Changes",delegate: self),
//            
//            ListsProgressElement(title: "List Progress", delegate: self, lists: []),
//
//            StoresMapElement(title: "Stores", stores: [], delegate: self, errorDelegate: self),
//
//            GroceryProductElement(title: "Grocery Items",delegate: self, scrollDelegate: self, products: []),
//
//            MonitoringProductElement(title: "Monitoring",delegate: self, scrollDelegate: self, products: []),
//
//            OffersElement(title: "Offers", delegate: self, promotions: []),
//
//            FeaturedProductElement(title: "Featured",delegate: self, products: []),
//            
//        ]
//        
//        if !loggedIn {
//            print("Removing Items")
//            customElements.remove(at: 0) // Hiding List Progress
//            customElements.remove(at: 1) // Hiding Grocery List Items
//            customElements.remove(at: 1) // Hiding Monitoring Items
//        }
//    }
//}
//
//extension HomeViewController {
//    func showListPage(){
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    func showProduct(productID: Int) {
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
//        destinationVC.productID = productID
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    func showPromotion(promotionID: Int) {
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "promotionViewController"))! as! PromotionViewController
//        destinationVC.promotionID = promotionID
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    func listSelected(identifier: String, listID: Int) {
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listViewController"))! as! ListViewController
//        destinationVC.identifier = identifier
//        destinationVC.listID = listID
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    func didScroll(to position: CGFloat, title: String) {
//        self.scrollPositions[title] = position
//        for item in customElements {
//            if item.title == title {
//                item.position = position
//            }
//        }
//    }
//    
//    func storePressed(storeID: Int) {
//        print("Store Selected")
//    }
//    
//    func storeSelected(storeID: Int) {
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "storeViewController"))! as! StoreViewController
//        destinationVC.storeID = storeID
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//}
//
//extension HomeViewController {
//    func addToHistory(_ homeItem: HomeModel){
//        
//        if home != nil {
//            print("Updating Home")
//            updateHistory(homeItem)
//        } else {
//            print("Creating Home")
//            let home:HomeHistory = HomeHistory()
//            
////            print("Reached 1")
//            
//            try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                homeItem.lists.forEach({
//                    let listHistory = $0.getRealmObject()
//                    listHistory.synced = true
//                    home.lists.append(listHistory)
//                })
//                                       
//                homeItem.stores.forEach({ home.stores.append( $0.getRealmObject() )})
//                homeItem.promotions.forEach({ home.promotions.append( $0.getRealmObject() )})
//                realm.add(home)
//            })
//                
////            print("Reached 2")
//            
//            var ignoreProducts: [Int: String] = [:]
//            
//            for product in homeItem.featured {
//                
//                try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                    
//                    if ignoreProducts[product.id] == nil {
//                        ignoreProducts[product.id] = product.name
//                        home.featured.append( product.getRealmObject() )
//                    } else {
//                        home.featured.append( realm.objects(ProductHistory.self).filter("id = \(product.id)").first! )
//                    }
//                    
//                })
//
//            }
//            
////            print("Reached 3")
//            
//            for product in homeItem.groceries {
//                
//                try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                    if ignoreProducts[product.id] == nil {
//                        ignoreProducts[product.id] = product.name
//                        home.groceries.append( product.getRealmObject() )
//                    } else {
//                        home.groceries.append( realm.objects(ProductHistory.self).filter("id = \(product.id)").first! )
//                    }
//                })
//
//            }
//            
////            print("Reached 4")
//            
//            try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                for product in homeItem.monitoring {
//                        
//                    let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//
//                    if productHistory != nil {
//                        // Product exists, set monitoring to true
//                        productHistory!.monitoring = true
//                    } else {
//                        // Create product, set monitoring to true
//                        let newProductHistory = product.getRealmObject()
//                        newProductHistory.monitoring = true
//                        ignoreProducts[product.id] = product.name
//                        realm.add(newProductHistory)
//                    }
//                    
//                }
//            })
//            
////            print("Reached 5")
//            
//            for category in homeItem.categories {
//                let categoryItem = FeaturedCategory()
//                categoryItem.name = category.key
//                
//                try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//                    for product in category.value {
//                        if ignoreProducts[product.id] == nil {
//                            ignoreProducts[product.id] = product.name
//                            categoryItem.products.append( product.getRealmObject() )
//                        } else {
//                            let productItem = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//                            
//                            if productItem != nil {
//                                categoryItem.products.append(productItem!)
//                            }
//                           
//                        }
//                    }
//
//                    home.categories.append(categoryItem)
//
//                })
//
//            }
//            
////            print("Reached 6")
//
//        }
//        
//    }
//    
//    func updateHistory(_ homeItem: HomeModel){
//        
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            
//            home!.lists.removeAll()
//            for list in homeItem.lists {
//
//                let listHistory = realm.objects(ListHistory.self).filter("identifier = %@", list.identifier).first
//
//                if listHistory != nil {
//                    
//                    if listHistory!.edited == false {
//                        listHistory!.name = list.name
//                        listHistory!.totalPrice = list.totalPrice
//                        listHistory!.status = list.status.rawValue
//                        listHistory!.tickedOffItems = list.tickedOffItems
//                        listHistory!.totalItems = list.totalItems
//                        listHistory!.updatedAt = Date()
//                    }
//                    
//                    home!.lists.append(listHistory!)
//                } else {
//                    home!.lists.append(list.getRealmObject())
//                }
//
//            }
//            
//        })
//            
//
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            home!.promotions.removeAll()
//            for promotion in homeItem.promotions {
//
//                let promotionHistory = realm.objects(PromotionHistory.self).filter("id = \(promotion.id)").first
//
//                if promotionHistory != nil {
//                    home!.promotions.append(promotionHistory!)
//                } else {
//                    home!.promotions.append(promotion.getRealmObject())
//                }
//
//            }
//        })
//
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            home!.featured.removeAll()
//            for product in homeItem.featured {
//
//                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//
//                if productHistory != nil {
//                    home!.featured.append(productHistory!)
//                } else {
//                    home!.featured.append(product.getRealmObject())
//                }
//
//            }
//        })
//        
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            home!.categories.removeAll()
//            realm.delete( realm.objects(FeaturedCategory.self) )
//
//            for category in homeItem.categories {
//                let categoryItem = FeaturedCategory()
//                categoryItem.name = category.key
//                
//                updateProducts(list: category.value, historyList: categoryItem.products)
//                home!.categories.append(categoryItem)
//            }
//        })
//        
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            updateProducts(list: homeItem.featured, historyList: home!.featured)
//        })
//        
//        
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            // Set all products to not monotirng, get products from home and set to monitoring. Create/update as required.
//            
//            let products = realm.objects(ProductHistory.self).filter("monitoring = true")
//            
//            for product in products {
//                product.monitoring = false
//            }
//            
//            for product in homeItem.monitoring {
//                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//                
//                if productHistory == nil {
//                    let newProductHistory = product.getRealmObject()
//                    newProductHistory.monitoring = true
//                    realm.add(newProductHistory)
//                } else {
//                    productHistory!.updatedAt = Date()
//                    productHistory!.monitoring = true
//                }
//               
//            }
//        })
//
//        try? realm.write(withoutNotifying: [listNotificationToken!, monitoredNotificationToken!], {
//            updateProducts(list: homeItem.groceries, historyList: home!.groceries)
//        })
//
//    }
//    
//    func updateProducts(list: [ProductModel], historyList: List<ProductHistory>){
//        historyList.removeAll()
//
//        for product in list {
//            let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//
//            if productHistory != nil {
//                historyList.append(productHistory!)
//            } else {
//                historyList.append(product.getRealmObject())
//            }
//        }
//        
//    }
//    
//}

//// Possible custom tablecell types with identifiers
//enum CustomElementType: String {
//    case products         = "ReusableProductTableViewCell"
//    case storesMap        = "ReusableStoresMapTableViewCell"
//    case listPriceUpdate  = "ReusableListPriceUpdateTableViewCell"
//    case listsProgress    = "ReusableListsProgressTableViewCell"
//    case offers           = "ReusableOffersTableViewCell"
//    case featuredProducts = "ReusableFeaturedProductTableViewCell"
//}
//
//// Each custom element model must have a defined type which is a custom element type.
//protocol CustomElementModel: class {
//    var title: String { get }
//    var type: CustomElementType { get }
//    var position: CGFloat? { get set }
//    var loading: Bool { get set }
//}
//
//protocol CustomElementCell: class {
//    func configure(withModel: CustomElementModel)
//}

extension UIImageView {
    func downloaded(from urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)  {
        if let url  = URL(string: urlString) {
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                options: [
                    .cacheOriginalImage,
                    .forceTransition,
                    .onFailureImage(KFCrossPlatformImage(named: "No Image")),
                    .scaleFactor(UIScreen.main.scale),
                ])
        }

    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 16 }
    var boldFontSize: CGFloat { return 17 }
    
    var boldFont:UIFont { return UIFont(name: "System", size: boldFontSize) ?? UIFont.boldSystemFont(ofSize: boldFontSize) }
    var normalFont:UIFont { return UIFont(name: "System", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
