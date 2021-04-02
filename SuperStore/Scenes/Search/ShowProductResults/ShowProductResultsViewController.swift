//
//  ShowProductResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowProductResultsDisplayLogic: class
{
    func displayResults(viewModel: ShowProductResults.GetResults.ViewModel)
    func displayListItems(viewModel: ShowProductResults.GetListItems.ViewModel)
    func displayListItemCreated(viewModel: ShowProductResults.CreateListItem.ViewModel)
    func displayListItemUpdated(viewModel: ShowProductResults.UpdateListItem.ViewModel)
}

class ShowProductResultsViewController: UIViewController, ShowProductResultsDisplayLogic
{
    
    var interactor: ShowProductResultsBusinessLogic?
    var router: (NSObjectProtocol & ShowProductResultsRoutingLogic & ShowProductResultsDataPassing)?
    
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
        let interactor = ShowProductResultsInteractor()
        let presenter = ShowProductResultsPresenter()
        let router = ShowProductResultsRouter()
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
        
        displayRightBarButton()
        getListItems()
        
        setupProductsTableView()
        displayTitle()
        
        getResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if interactor?.selectedListID != nil {
            getResults()
            getListItems()
        }
        
        if currentLoggedIn != loggedIn {
            currentLoggedIn = loggedIn
            productsTableView.reloadData()
        }
    }
    
    
    var uniqueProducts: [Int: Bool] = [:]
    
    var loading: Bool = true
    var refreshControl = UIRefreshControl()
    
    var currentPage: Int = 1
    
    @IBOutlet var totalProductsLabel: UILabel!
    @IBOutlet var productsTableView: UITableView!
    
    var paginate: PaginateResultsModel?
    
    var products: [ProductModel] = []
    var listItems: [Int: ListItemModel] = [:]
    
    var selectedProduct: ProductModel?
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }
    
    var currentLoggedIn: Bool = false
    
    func getResults(){
        loading = true
        productsTableView.reloadData()
        totalProductsLabel.text = "Fetching Products"
        
        let request = ShowProductResults.GetResults.Request(page: currentPage, refine: false)
        interactor?.getResults(request: request)
    }
    
    func getListItems(){
        let request = ShowProductResults.GetListItems.Request()
        interactor?.getListItems(request: request)
    }
    
    func refineResults(){
        loading = true
        currentPage = 1
        
        productsTableView.reloadData()
        
        let request = ShowProductResults.GetResults.Request(refine: true)
        totalProductsLabel.text = "Refining Search Results"
        interactor?.getResults(request: request)
    }
    
    //MARK: - Display
    
    func displayResults(viewModel: ShowProductResults.GetResults.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            if !viewModel.offline {
                showError(title: "Search Error", error: error)
            }
        } else {
            loading = false
            paginate = viewModel.paginate
            
            if let paginate = viewModel.paginate, paginate.current > 1 {
                for product in viewModel.products {
                    if uniqueProducts[product.id] == nil {
                        uniqueProducts[product.id] = true
                        products.append(product)
                    }
                }
            } else {
                uniqueProducts = [:]
                products = []
                
                for product in viewModel.products {
                    products.append(product)
                    uniqueProducts[product.id] = true
                }
            }
            
            totalProductsLabel.text = "\(products.count) Products"
            productsTableView.reloadData()
        }
        
    }
    
    func displayListItems(viewModel: ShowProductResults.GetListItems.ViewModel) {
        self.listItems = viewModel.listItems
    }
    
    func displayListItemCreated(viewModel: ShowProductResults.CreateListItem.ViewModel) {
        if let error = viewModel.error, !viewModel.offline {
            showError(title: "List Error", error: error)
        } else {
            // If list item exists locally,
            if let listItem = viewModel.listItem {
                updateProductQuantity(productID: listItem.productID, quantity: listItem.quantity)
                productsTableView.reloadData()
            }
        }
    }
    
    func displayListItemUpdated(viewModel: ShowProductResults.UpdateListItem.ViewModel) {
        if let error = viewModel.error, !viewModel.offline {
            showError(title: "List Error", error: error)
        }
    }
    
    func displayRightBarButton(){
        if interactor?.selectedListID == nil {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func displayTitle(){
        title = interactor!.searchQueryRequest.query
    }
}

extension ShowProductResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? (products.count == 0 ? 5 : products.count) : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureProductCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loading {
            router?.selectedProductID = products[indexPath.row].id
            router?.routeToShowProduct(segue: nil)
        }
    }
    
    func configureProductCell(indexPath: IndexPath) -> ProductCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let product: ProductModel? = loading ? nil : products[indexPath.row]
        
        // check if found in locally saved list items. If found, update quantity, otherwise ignore
        if !loading, let product = product, let listItem = listItems[product.id]{
            product.quantity = listItem.quantity
            product.listID = interactor?.selectedListID!
        }
        
        loadMoreProducts(indexPath: indexPath)
        
        cell.loading = loading
        cell.product = product
        cell.addToList = loggedIn
        cell.addToListPressed = addToListPressed
        cell.updateQuantityPressed = updateQuantityPressed
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func setupProductsTableView(){
        let productCellNib = UINib(nibName: "ProductCell", bundle: nil)
        productsTableView.register(productCellNib, forCellReuseIdentifier: "ProductCell")
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        
        setupRefreshControl()
    }
    
    private func loadMoreProducts(indexPath: IndexPath){
        // If last row, not loading and more products avaialable. Then load more products.
        if !loading, let paginate = paginate, paginate.moreAvailable, indexPath.row == (products.count - 1) {
            loading = true
            currentPage = currentPage + 1
            getResults()
        }
    }
    
    private func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshResults), for: .valueChanged)
        productsTableView.addSubview(refreshControl)
    }
    
    @objc func refreshResults(){
        getResults()
        getListItems()
    }
    
}

extension ShowProductResultsViewController: SelectListProtocol {
    
    func addToListPressed(product: ProductModel){
        // Show lists, select one.
        selectedProduct = product
        
        if let listID = interactor?.selectedListID {
            createListItem(listID: listID)
            updateProductQuantity(productID: product.id, quantity: 1, listID: interactor?.selectedListID)
            productsTableView.reloadData()
        } else {
            interactor?.selectedProductStoreTypeID = product.storeTypeID
            router?.routeToShowLists(segue: nil)
        }
    }
    
    func listSelected(listID: Int) {
        // Update Cell Quantity Button
        updateProductQuantity(productID: selectedProduct!.id, quantity: 1, listID: listID)
        createListItem(listID: listID)
        productsTableView.reloadData()
    }
    
    func createListItem(listID: Int){
        let request = ShowProductResults.CreateListItem.Request(
            listID: listID,
            product: selectedProduct!
        )
        
        interactor?.createListItem(request: request)
    }
    
    func updateQuantityPressed(product: ProductModel){
        // Update API/Realm Request
        selectedProduct = product
        
        if let listID = product.listID {
            updateProductQuantity(productID: product.id, quantity: product.quantity)
            
            let request = ShowProductResults.UpdateListItem.Request(
                listID: listID,
                productID: product.id,
                quantity: product.quantity
            )
            
            interactor?.updateListItem(request: request)
        }
    }
    
    func updateProductQuantity(productID: Int, quantity: Int, listID: Int? = nil){
//        print("productID: \(productID), quantity: \(quantity), listID: \(listID) ")
        for searchProduct in products {
            if searchProduct.id == productID {
                searchProduct.quantity = quantity
                if quantity == 0 {
                    searchProduct.listID = nil
                } else if listID != nil {
                    searchProduct.listID = listID!
                }
            }
        }
    }
}

extension ShowProductResultsViewController {
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        router?.routeToShowList(segue: nil)
    }
}


