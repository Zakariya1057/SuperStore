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

protocol HomeDisplayLogic: class
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
        
        setupHomeCells()
        registerTableViewCells()
        getHome()
    }
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    var scrollPositions: [String: CGFloat] = [:]
    var homeCells: [CustomElementModel] = []
    
    var homeModel: HomeModel?
    var loading: Bool = false
    
    var selectedProductID: Int?
    var selectedPromotionID: Int?
    var selectedStoreID: Int?
    
    func getHome()
    {
        let request = Home.GetHome.Request()
        interactor?.getHome(request: request)
    }
    
    //MARK: - Display
    
    func displayHome(viewModel: Home.GetHome.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            showError(title: "Home Error", error: error)
        } else {
            homeModel = viewModel.home
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
                
                case is StoresMapElement:
                    let storeElement = element as! StoresMapElement
                    storeElement.stores = homeModel.stores
                    break
                case is GroceryProductElement:
                    let productElement = element as! GroceryProductElement
                    productElement.products = homeModel.groceries
                    break
                case is MonitoringProductElement:
                    let productElement = element as! MonitoringProductElement
                    productElement.products = homeModel.monitoring.reversed()
                    break
                case is OffersElement:
                    let offerElement = element as! OffersElement
                    offerElement.promotions = homeModel.promotions
                    break
                case is FeaturedProductElement:
                    let featuredElement = element as! FeaturedProductElement
                    featuredElement.products = homeModel.featured
                case is ListsProgressElement:
                    let listProgressElement = element as! ListsProgressElement
                    listProgressElement.lists = homeModel.lists
                    break
                default:
                    print("Unknown Type Encountered: \(element.type)")
                }
                
            }
            
            for category in homeModel.categories {
                let name = category.key
                let products = category.value
                let element = ProductElement(title: name, productPressedCallBack: productPressed, scrollCallBack: cellScroll, products: products)
                homeCells.append(element)
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
        
        let listsProgressCell = UINib(nibName: "ListsProgressCell", bundle: nil)
        tableView.register(listsProgressCell, forCellReuseIdentifier: "ListsProgressCell")
        
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
    
    private func setupHomeCells(){
        homeCells = [
            ListsProgressElement(title: "List Progress", listPressedCallBack: listPressed, lists: []),
            StoresMapElement(title: "Stores", storePressed: storePressed, stores: []),
            GroceryProductElement(title: "Grocery Items", productPressedCallBack: productPressed, scrollCallBack: cellScroll, products: []),
            MonitoringProductElement(title: "Monitoring", productPressedCallBack: productPressed, scrollCallBack: cellScroll, products: []),
            OffersElement(title: "Offers", offerPressedCallBack: promotionPressed, promotions: []),
            FeaturedProductElement(title: "Featured", productPressedCallBack: productPressed, scrollCallBack: {_,_ in }, products: [])
        ]
    }
}

extension HomeViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeCells.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = homeCells[section].title
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! SectionHeader
        header.headingLabel.text = title
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = homeCells[indexPath.section]
        print(cellModel.type)
        let cellIdentifier = cellModel.type.rawValue
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomElementCell
        
        cellModel.position = scrollPositions[ cellModel.title ]
        cellModel.loading = self.loading
        customCell.configure(withModel: cellModel)
        
        let cell = customCell as! UITableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}

extension HomeViewController {
    private func promotionPressed(promotionID: Int){
        selectedPromotionID = promotionID
        router?.routeToShowPromotion(segue: nil)
    }
    
    private func storePressed(storeID: Int){
        selectedStoreID = storeID
        router?.routeToStore(segue: nil)
        print("Store Pressed")
    }
    
    private func listPressed(listID: Int){
        print("List Pressed")
    }
    
    private func productPressed(productID: Int){
        self.selectedProductID = productID
        router?.routeToShowProduct(segue: nil)
    }
    
    private func cellScroll(position: CGFloat, title: String){
        scrollPositions[title] = position
    }
}

enum CustomElementType: String {
    case products         = "ProductsCell"
    case storesMap        = "StoresMapCell"
    case listsProgress    = "ListsProgressCell"
    case offers           = "OffersCell"
    case featuredProducts = "FeaturedProductCell"
    case listPriceUpdate  = "ListPriceUpdate"
}

// Each custom element model must have a defined type which is a custom element type.
protocol CustomElementModel: class {
    var title: String { get }
    var type: CustomElementType { get }
    var position: CGFloat? { get set }
    var loading: Bool { get set }
}

protocol CustomElementCell: class {
    func configure(withModel: CustomElementModel)
}
