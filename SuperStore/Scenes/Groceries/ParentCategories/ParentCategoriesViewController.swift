//
//  ParentCategoriesViewController.swift
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

protocol ParentCategoriesDisplayLogic: class
{
    func displayCategories(viewModel: ParentCategories.GetCategories.ViewModel)
}

class ParentCategoriesViewController: UIViewController, ParentCategoriesDisplayLogic
{
    var interactor: ParentCategoriesBusinessLogic?
    var router: (NSObjectProtocol & ParentCategoriesRoutingLogic & ParentCategoriesDataPassing)?
    
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
        let interactor = ParentCategoriesInteractor()
        let presenter = ParentCategoriesPresenter()
        let router = ParentCategoriesRouter()
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
        setupCategoriesTableView()
        getCategories()
    }
    
    // MARK: Do something
    
    @IBOutlet var categoriesTableView: UITableView!

    var categories: [ParentCategories.GetCategories.ViewModel.DisplayedCategory] = []
    
    func getCategories()
    {
        let request = ParentCategories.GetCategories.Request()
        interactor?.getCategories(request: request)
    }
    
    func displayCategories(viewModel: ParentCategories.GetCategories.ViewModel)
    {
        categories =  viewModel.displayedCategories
        categoriesTableView.reloadData()
    }
}

extension ParentCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCategoryCell(indexPath: indexPath)
    }
    
    func configureCategoryCell(indexPath: IndexPath) -> CategoryTableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.nameLabel.text = categories[indexPath.row].name
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func setupCategoriesTableView(){
        let categoryCellNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        categoriesTableView.register(categoryCellNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
}

extension ParentCategoriesViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToChildCategories(segue: nil)
    }
}


