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
        setupProductsTableView()
        updateTitle()
        getResults()
    }
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var totalProductsLabel: UILabel!
    @IBOutlet var productsTableView: UITableView!
    
    var products: [ProductModel] = []
    
    var selectedListID: Int?
    var selectedProduct: ProductModel?
    
    func updateTitle(){
        title = interactor!.productQueryModel.query
    }
    
    func getResults()
    {
        let request = ShowProductResults.GetResults.Request()
        totalProductsLabel.text = "Loading Products"
        interactor?.getResults(request: request)
    }
    
    func refineResults(){
        let request = ShowProductResults.GetResults.Request()
        totalProductsLabel.text = "Refining Search Results"
        interactor?.getResults(request: request)
    }
    
    
    
    func displayResults(viewModel: ShowProductResults.GetResults.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            showError(title: "Search Error", error: error)
        } else {
            products = viewModel.products
            totalProductsLabel.text = "\(products.count) Products"
            productsTableView.reloadData()
        }
    }
    
    func displayListItemCreated(viewModel: ShowProductResults.CreateListItem.ViewModel) {
        if let error = viewModel.error {
            showError(title: "List Error", error: error)
        }
    }
    
    func displayListItemUpdated(viewModel: ShowProductResults.UpdateListItem.ViewModel) {
        if let error = viewModel.error {
            showError(title: "List Error", error: error)
        }
    }
    
    func displayRightBarButton(){
        if interactor?.selectedListID == nil {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}

extension ShowProductResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureProductCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.selectedProductID = products[indexPath.row].id
        router?.routeToShowProduct(segue: nil)
    }
    
    func configureProductCell(indexPath: IndexPath) -> ProductCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.product = products[indexPath.row]
        cell.addToList = true
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
    
    private func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshResults), for: .valueChanged)
        productsTableView.addSubview(refreshControl)
    }
    
    @objc func refreshResults(){
        getResults()
    }
    
}

extension ShowProductResultsViewController: SelectListProtocol {
    func listSelected(listID: Int) {
        // Update Cell Quantity Button
        createListItem(listID: listID)
    }
    
    func addToListPressed(product: ProductModel){
        // Show lists, select one.
        selectedProduct = product
        updateProductQuantity(product: product)
        
        if let listID = interactor?.selectedListID {
            createListItem(listID: listID)
        } else {
            router?.routeToShowLists(segue: nil)
        }
    }
    
    func createListItem(listID: Int){
        let request = ShowProductResults.CreateListItem.Request(
            listID: listID,
            productID: selectedProduct!.id,
            parentCategoryID: selectedProduct!.parentCategoryId!
        )
        
        interactor?.createListItem(request: request)
        
        selectedListID = listID
        productsTableView.reloadData()
    }
    
    func updateQuantityPressed(product: ProductModel){
        // Update API/Realm Request
        selectedProduct = product
        updateProductQuantity(product: product)
        
        let request = ShowProductResults.UpdateListItem.Request(
            listID: selectedListID!,
            productID: product.id,
            quantity: product.quantity
        )
        
        interactor?.updateListItem(request: request)
    }
    
    func updateProductQuantity(product: ProductModel){
        for searchProduct in products {
            if searchProduct == product {
                searchProduct.quantity = product.quantity
            }
        }
    }
}

extension ShowProductResultsViewController {
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
}


