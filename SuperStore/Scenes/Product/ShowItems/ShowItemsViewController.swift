//
//  ShowIngredientsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowItemsDisplayLogic: AnyObject
{
    func displayItems(viewModel: ShowItems.GetItems.ViewModel)
}

class ShowItemsViewController: UIViewController, ShowItemsDisplayLogic
{
    var interactor: ShowIngredientsBusinessLogic?
    var router: (NSObjectProtocol & ShowItemsRoutingLogic & ShowIngredientsDataPassing)?
    
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
        let interactor = ShowItemsInteractor()
        let presenter = ShowItemsPresenter()
        let router = ShowItemsRouter()
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
        setupTableView()
        getItems()
    }
    

    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var items: [String] = []
    
    func getItems()
    {
        let request = ShowItems.GetItems.Request()
        interactor?.getItems(request: request)
    }
    
    func displayItems(viewModel: ShowItems.GetItems.ViewModel)
    {
        title = viewModel.title
        items = viewModel.items
        ingredientsTableView.reloadData()
    }
}

extension ShowItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView(){
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 50
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
