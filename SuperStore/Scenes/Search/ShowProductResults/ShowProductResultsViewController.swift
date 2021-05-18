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

protocol ShowProductResultsDisplayLogic: AnyObject
{
    func displayResults(viewModel: ShowProductResults.GetResults.ViewModel)
    func displayListItems(viewModel: ShowProductResults.GetListItems.ViewModel)
    func displayListItemCreated(viewModel: ShowProductResults.CreateListItem.ViewModel)
    func displayListItemUpdated(viewModel: ShowProductResults.UpdateListItem.ViewModel)
    
    func displayCategoryProducts(viewModel: ShowProductResults.GetCategoryProducts.ViewModel)
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
        
        getProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if interactor?.selectedListID != nil {
            getProducts()
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
    
    @IBOutlet weak var refineButton: UIButton!
    
    @IBOutlet var totalProductsLabel: UILabel!
    @IBOutlet var productsTableView: UITableView!
    
    @IBAction func refineButton(_ sender: Any) {
    }
    var paginate: PaginateResultsModel?
    
    var products: [ProductModel] = []
    var listItems: [Int: ListItemModel] = [:]
    
    var selectedProduct: ProductModel?
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }
    
    var currentLoggedIn: Bool = false
    
    func getProducts(refineSort: Bool = false){
        // If category products or search results
        if interactor?.childCategoryID == nil {
            getResults(refineSort: refineSort)
        } else {
            getCategoryProducts(refineSort: refineSort)
        }
    }
    
    func getResults(refineSort: Bool = false){
        if !refineSort {
            totalProductsLabel.text = "Fetching Products"
        }
        
        let request = ShowProductResults.GetResults.Request(page: currentPage, refineSort: refineSort)
        interactor?.getResults(request: request)
    }
    
    func getListItems(){
        let request = ShowProductResults.GetListItems.Request()
        interactor?.getListItems(request: request)
    }
    
    func getCategoryProducts(refineSort: Bool = false){
        if !refineSort {
            totalProductsLabel.text = "Fetching Products"
        } else {
            totalProductsLabel.text = "Refining Results"
        }
        
        let request = ShowProductResults.GetCategoryProducts.Request(page: currentPage, refineSort: refineSort)
        interactor?.getCategoryProducts(request: request)
    }
    
    func refineSortResults(title: String){
        loading = true
        products = []
        currentPage = 1
        
        if products.count > 0 {
            productsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        productsTableView.reloadData()

        totalProductsLabel.text = title
        
        getListItems()
        getProducts(refineSort: true)
    }
    
    //MARK: - Display
    
    func displayResults(viewModel: ShowProductResults.GetResults.ViewModel)
    {
        refreshControl.endRefreshing()
        
        let products: [ProductModel] = viewModel.products
        let paginate: PaginateResultsModel? = viewModel.paginate
        
        showProducts(products: products, paginate:paginate, error: viewModel.error, offline: viewModel.offline)
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
        title = interactor!.childCategoryID == nil ? interactor!.searchQueryRequest.query : interactor!.title
    }
    
    
    // Child Category Products
    func displayCategoryProducts(viewModel: ShowProductResults.GetCategoryProducts.ViewModel) {
        refreshControl.endRefreshing()
        
        let category: ChildCategoryModel? = viewModel.category
        
        let products: [ProductModel] = category?.products ?? []
        let paginate: PaginateResultsModel? = category?.paginate
        
        showProducts(products: products, paginate:paginate, error: viewModel.error, offline: viewModel.offline)
    }
    
    func showProducts(products resultsProducts: [ProductModel], paginate resultsPaginate: PaginateResultsModel?, error: String? = nil, offline: Bool = false){
        if let error = error {
            if !offline {
                showError(title: "Products Error", error: error)
            }
        } else {
            loading = false
            paginate = resultsPaginate
            
            if let paginate = resultsPaginate {
                if paginate.current > 1 {
                    for product in resultsProducts {
                        if uniqueProducts[product.id] == nil {
                            uniqueProducts[product.id] = true
                            products.append(product)
                        }
                    }
                } else {
                    uniqueProducts = [:]
                    products = []

                    for product in resultsProducts {
                        products.append(product)
                        uniqueProducts[product.id] = true
                    }
                }
            } else {
                products = resultsProducts
            }
            
            totalProductsLabel.text = "\(products.count) Products"

            productsTableView.reloadData()
        }
        
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
            currentPage = currentPage + 1
            getProducts()
        }
    }
    
    private func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshResults), for: .valueChanged)
        productsTableView.addSubview(refreshControl)
    }
    
    @objc func refreshResults(){
        getProducts()
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

extension ShowProductResultsViewController {
    @IBAction func showAlert(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortOptions: [RefineSortOptionModel] = [
            RefineSortOptionModel(name: "Relevance", type: .relevance),
            
            RefineSortOptionModel(name: "Price - High To Low", type: .price, order: .desc),
            RefineSortOptionModel(name: "Price - Low To High", type: .price, order: .asc),
            
            RefineSortOptionModel(name: "Rating - High To Low", type: .rating, order: .desc),
            RefineSortOptionModel(name: "Rating - Low To High", type: .rating, order: .asc)
        ]
        
        for option in sortOptions {
            alert.addAction(UIAlertAction(title: option.name, style: .default , handler:{ _ in self.sortOptionSelected(option: option) }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        if let viewRect = sender as? UIView {
            
            alert.modalPresentationStyle = .popover
            
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = viewRect;
                presenter.sourceRect = viewRect.bounds;
            }

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    }
    
    private func sortOptionSelected(option: RefineSortOptionModel){
        interactor?.sortOptionSelected(option: option)
        refineSortResults(title: "Sorting Results")
    }
}
