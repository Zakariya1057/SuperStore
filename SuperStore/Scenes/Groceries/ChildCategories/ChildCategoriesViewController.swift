//
//  ChildCategoriesViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Tabman
import Pageboy

protocol ChildCategoriesDisplayLogic: class
{
    func displayCategories(viewModel: ChildCategories.GetCategories.ViewModel)
}

class ChildCategoriesViewController: TabmanViewController, ChildCategoriesDisplayLogic
{
    
    var interactor: ChildCategoriesBusinessLogic?
    var router: (NSObjectProtocol & ChildCategoriesRoutingLogic & ChildCategoriesDataPassing)?
    
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
        let interactor = ChildCategoriesInteractor()
        let presenter = ChildCategoriesPresenter()
        let router = ChildCategoriesRouter()
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
        setupBar()
        getCategories()
    }
    
    var selectedProductID: Int?
    
    var viewcontrollers:[GroceryTableViewController] = []
    var categories: [ChildCategoryModel] = []
    
    let bar = TMBar.ButtonBar()
    
    func getCategories()
    {
        let request = ChildCategories.GetCategories.Request()
        interactor?.getCategories(request: request)
    }
    
    func displayCategories(viewModel: ChildCategories.GetCategories.ViewModel)
    {
        if let error = viewModel.error {
            showError(title: "Grocery Error", error: error)
        } else {
            self.categories = viewModel.categories
            viewcontrollers = categories.map { _ in GroceryTableViewController(nibName: nil, bundle: nil) }
            self.reloadData()
        }
    }
}

extension ChildCategoriesViewController {
    func setupBar(){
        self.dataSource = self
        configureBar()
    }
    
    func configureBar(){
        bar.tintColor = UIColor(named: "Label Color")

        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 1.0, right: 16.0)
        bar.layout.interButtonSpacing = 30.0

        bar.layout.showSeparators = true
        bar.layout.separatorColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        bar.layout.separatorWidth = 0.5

        bar.backgroundView.style = .flat(color:  UIColor(named: "LightGrey")!)
        bar.backgroundColor = UIColor(named: "LightGrey")

        bar.indicator.weight = .medium
        bar.indicator.cornerStyle = .square
        bar.fadesContentEdges = true
        bar.spacing = 30.0

        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}

extension ChildCategoriesViewController:  TMBarDataSource, PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: categories[index].name)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewcontrollers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let viewController: GroceryTableViewController = viewcontrollers[index]

        if categories.indices.contains(index) {
            viewController.products = categories[index].products
            viewController.productPressedCallBack = productPressed
        }

        return viewController
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension ChildCategoriesViewController {
    private func productPressed(productID: Int){
        self.selectedProductID = productID
        router?.routeToShowProduct(segue: nil)
    }
}
