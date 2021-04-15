//
//  HomeViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit
import NotificationBannerSwift
import Kingfisher

protocol HomeDisplayLogic: AnyObject
{
    func displayHome(viewModel: Home.GetHome.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic
{
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        
        registerTableViewCells()
        setupHomeCells()
        currentStoreTypeID = userSession.getStore()
        getHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userSession.getStore() != currentStoreTypeID || currentLoggedIn != loggedIn {
            currentStoreTypeID = userSession.getStore()
            currentLoggedIn = loggedIn
            getHome()
        }
    }
    
    // Used to decide to refresh page or not
    var currentLoggedIn: Bool = false
    var currentStoreTypeID: Int = 0
    
    var loading: Bool = true
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    var scrollPositions: [String: CGFloat] = [:]
    
    var homeCells: [HomeElementGroupModel] = []
    
    var errorMessageDisplayed: Bool = false
    var homeModel: HomeModel?
    
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }
    
    func getHome()
    {
        let request = Home.GetHome.Request(latitude: latitude, longitude: longitude)
        interactor?.getHome(request: request)
    }
    
    //MARK: - Display
    
    func displayHome(viewModel: Home.GetHome.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            if !errorMessageDisplayed && !viewModel.offline {
                errorMessageDisplayed = true
                showError(title: "Home Error", error: error)
            }
        } else {
            homeModel = viewModel.home
            loading = false
            errorMessageDisplayed = false
            populateCells()
        }
    }
}

extension HomeViewController {
    private func populateCells(){
        if let homeModel = homeModel {
            
            setupHomeCells()
            
            for element in homeCells {
                
                switch element {
                
                case is ListGroupProgressElement:
                    let listProgressElement = element as! ListGroupProgressElement
                    listProgressElement.items = homeModel.lists.map { ListProgressElement(list: $0) }
                    listProgressElement.configurePressed()
                    listProgressElement.setLoading(loading: loading)
                    break
                    
                case is StoreMapGroupElement:
                    let storeElement = element as! StoreMapGroupElement
                    storeElement.items = [ StoresMapElementModel(stores: homeModel.stores) ]
                    storeElement.configurePressed()
                    break
                    
                case is GroceryProductGroupElement:
                    let productElement = element as! GroceryProductGroupElement
                    productElement.items = [ ProductsElementModel(products: homeModel.groceries) ]
                    productElement.configureProduct()
                    productElement.setLoading(loading: loading)
                    break
                    
                case is MonitoringProductGroupElement:
                    let productElement = element as! MonitoringProductGroupElement
                    productElement.items =  [ ProductsElementModel(products: homeModel.monitoring) ]
                    productElement.configureProduct()
                    productElement.setLoading(loading: loading)
                    break
                    
                case is PromotionGroupElement:
                    let offerElement = element as! PromotionGroupElement
                    offerElement.items = [ PromotionsElementModel(promotions: homeModel.promotions) ]
                    offerElement.configurePressed()
                    offerElement.setLoading(loading: loading)
                    break
                    
                case is FeaturedProductGroupElement:
                    let featuredElement = element as! FeaturedProductGroupElement
                    featuredElement.items = [ FeaturedProductsElementModel(products: homeModel.featured) ]
                    featuredElement.configurePressed()
                    featuredElement.setLoading(loading: loading)
                    break

                default:
                    print("Unknown Cell Type Encountered: \(element.type)")
                }
                
            }
            
            for category in homeModel.categories {
                let name = category.name
                let products = category.products

                let productCell = ProductsElementModel(products: products)
                
                productCell.title = name
                
                let categoryCell = CategoryProductGroupElement(title: name, products: [productCell], productPressed: productPressed)
                
                categoryCell.setLoading(loading: loading)
                
                productCell.parentScrolled = cellScroll
                
                if let position = scrollPositions[name] {
                    productCell.scrollPosition = position
                }
                
                homeCells.append(categoryCell)
            }
            
            tableView.reloadData()
            
        }
        
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    private func registerTableViewCells(){
        let headerNib = UINib(nibName: "SectionHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
        let productsCellNib = UINib(nibName: "ProductsCell", bundle: nil)
        tableView.register(productsCellNib, forCellReuseIdentifier: "ProductsCell")
        
        let storesCell = UINib(nibName: "StoresMapCell", bundle: nil)
        tableView.register(storesCell, forCellReuseIdentifier: "StoresMapCell")
        
        let offersCell = UINib(nibName: "OffersCell", bundle: nil)
        tableView.register(offersCell, forCellReuseIdentifier: "OffersCell")
        
        let featuredProductsCell = UINib(nibName: "FeaturedProductCell", bundle: nil)
        tableView.register(featuredProductsCell, forCellReuseIdentifier: "FeaturedProductCell")
        
        let listsProgressCell = UINib(nibName: "ListProgressCell", bundle: nil)
        tableView.register(listsProgressCell, forCellReuseIdentifier: "ListProgressCell")
        
        setUpTableView()
        setupRefreshControl()
    }
    
    private func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshHome), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshHome(){
        getHome()
    }
    
    private func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension HomeViewController {
    private func setupHomeCells(){
        homeCells = [
            ListGroupProgressElement(title: "List Progress", lists: [], listPressed: listPressed),
            StoreMapGroupElement(title: "Stores", stores: [], storePressed: storePressed, userLocationFetched: userLocationFetched),
            GroceryProductGroupElement(title: "Grocery Items", products: [], productPressed: productPressed),
            MonitoringProductGroupElement(title: "Monitoring", products: [], productPressed: productPressed),
            PromotionGroupElement(title: "Promotions", promotions: [], promotionPressed: promotionPressed),
            FeaturedProductGroupElement(title: "Featured", products: [], productPressed: productPressed),
        ]
        
        if loading {
            homeCells.append(CategoryProductGroupElement(title: "Fruit", products: [], productPressed: productPressed))
            homeCells.append(CategoryProductGroupElement(title: "Vegetables & Potatoes", products: [], productPressed: productPressed))
        }
        
        currentLoggedIn = loggedIn
        
        if !loggedIn {
            removeLoggedOutCells()
        }
        
        hideEmptyCells()
    }
    
    private func removeLoggedOutCells(){
        homeCells.removeAll { (element: HomeElementGroupModel) -> Bool in
            if element is ListGroupProgressElement
                || element is GroceryProductGroupElement
                || element is MonitoringProductGroupElement
            {
                return true
            }
            
            return false
        }
    }
    
    private func hideEmptyCells(){
        if homeModel?.monitoring.count == 0 {
            homeCells.removeAll { (element: HomeElementGroupModel) -> Bool in
                return element is MonitoringProductGroupElement
            }
        }
        
        if homeModel?.groceries.count == 0 {
            homeCells.removeAll { (element: HomeElementGroupModel) -> Bool in
                return element is GroceryProductGroupElement
            }
        }
        
        if homeModel?.lists.count == 0 {
            homeCells.removeAll { (element: HomeElementGroupModel) -> Bool in
                return element is ListGroupProgressElement
            }
        }
    }
}


extension HomeViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeCells.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! SectionHeader
        
        if section < homeCells.count {
            header.headingLabel.text = homeCells[section].title
        }

        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 1 : homeCells[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = homeCells[indexPath.section]
        
        var customCell: HomeElementCell
        var cellModel: HomeElementItemModel
        let cellIdentifier: String = group.type.rawValue
        
        if !loading {
            cellModel = group.items[indexPath.row]
        } else {
            cellModel = createElementModel(group: group)
        }

        customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeElementCell
        customCell.configure(model: cellModel)
        
        let cell = customCell as! UITableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}

extension HomeViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loading {
            if let group = homeCells[indexPath.section] as? ListGroupProgressElement {
                let list = group.items[indexPath.row] as! ListProgressElement
                if list.list != nil {
                    listPressed(list: list.list!)
                }
            }
        }
    }
}

extension HomeViewController {
    func createElementModel(group: HomeElementGroupModel) -> HomeElementItemModel {
        var cellModel: HomeElementItemModel
        
        switch group {
        
        case is ProductGroupElement:
            cellModel = ProductsElementModel(products: [])
            break
            
        case is StoreMapGroupElement:
            let storeElement = StoresMapElementModel(stores: [])
            storeElement.userLocationFetched = userLocationFetched
            cellModel = storeElement
            break
            
        case is ListGroupProgressElement:
            cellModel = ListProgressElement(list: nil)
            break
            
        case is FeaturedProductGroupElement:
            cellModel = FeaturedProductsElementModel(products: [])
            break
            
        case is PromotionGroupElement:
            cellModel = PromotionsElementModel(promotions: [])
            break
            
        default:
            cellModel = ProductsElementModel(products: [])
        }
        
        return cellModel
    }
}

extension HomeViewController {
    private func promotionPressed(promotionID: Int){
        router?.selectedPromotionID = promotionID
        router?.routeToShowPromotion(segue: nil)
    }
    
    private func storePressed(storeID: Int){
        router?.selectedStoreID = storeID
        router?.routeToStore(segue: nil)
    }
    
    private func listPressed(list: ListModel){
        router?.selectedList = list
        router?.routeToShowList(segue: nil)
    }
    
    private func productPressed(productID: Int){
        router?.selectedProductID = productID
        router?.routeToShowProduct(segue: nil)
    }
    
    private func cellScroll(title: String, position: CGFloat){
        scrollPositions[title] = position
    }
}

extension HomeViewController {
    private func userLocationFetched(location: CLLocationCoordinate2D?){
        
        if let location = location {
            longitude = Double(location.longitude)
            latitude = Double(location.latitude)
            
            let request = Home.UpdateLocation.Request(longitude: longitude!, latitude: latitude!)
            interactor?.updateLocation(request: request)
        } else {
            // No location found
            if(homeModel == nil){
                let banner = StatusBarNotificationBanner(title: "Please enable user location to see nearby stores.", style: .info)
                banner.dismissOnTap = true
                banner.dismissOnSwipeUp = true
                banner.show()
            }
        }

        if homeModel == nil {
            getHome()
        }
    }
}

protocol HomeElementGroupModel: AnyObject {
    var title: String { get }
    var type: HomeElementType { get }
    var items: [HomeElementItemModel] { get }
    var loading: Bool { get set }
}

protocol HomeElementItemModel: AnyObject {
    var loading: Bool { get set }
}

protocol HomeElementCell: AnyObject {
    func configure(model: HomeElementItemModel)
}

enum HomeElementType: String {
    case products         = "ProductsCell"
    case storesMap        = "StoresMapCell"
    case listsProgress    = "ListProgressCell"
    case offers           = "OffersCell"
    case featuredProducts = "FeaturedProductCell"
    case listPriceUpdate  = "ListPriceUpdate"
}
