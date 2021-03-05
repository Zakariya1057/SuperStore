//
//  ShowListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowListDisplayLogic: class
{
    func displayList(viewModel: ShowList.GetList.ViewModel)
}

class ShowListViewController: UIViewController, ShowListDisplayLogic
{
    var interactor: ShowListBusinessLogic?
    var router: (NSObjectProtocol & ShowListRoutingLogic & ShowListDataPassing)?
    
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
        let interactor = ShowListInteractor()
        let presenter = ShowListPresenter()
        let router = ShowListRouter()
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
        
        setupListSectionView()
        setupListItemTableView()
        
        displayListName()
        getList()
    }
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var itemsTableView: UITableView!
    
    @IBOutlet var oldPriceView: UIView!
    @IBOutlet var oldPriceLabel: UILabel!
    
    @IBOutlet var totalPriceLabel: UILabel!
    
    var list: ListModel! {
        return interactor!.list
    }
    
    var displayedList: ShowList.DisplayedList? = nil
    
    func getList()
    {
        let request = ShowList.GetList.Request(listID: list.id)
        interactor?.getList(request: request)
    }
    
    func displayList(viewModel: ShowList.GetList.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            showError(title: "List Error", error: error)
        } else {
           
            if let displayedList = viewModel.displayedList {
                self.displayedList = displayedList
                displayPrice()
                itemsTableView.reloadData()
            }
        }
    }

    func displayPrice(){
        totalPriceLabel.text = displayedList!.totalPrice
    }
    
    func displayListName(){
        title = list.name
    }
}

extension ShowListViewController: UITableViewDataSource, UITableViewDelegate {
    func setupListSectionView(){
        let listSectionNib = UINib(nibName: "ListSectionHeader", bundle: nil)
        itemsTableView.register(listSectionNib, forHeaderFooterViewReuseIdentifier: "ListSectionHeader")
    }
    
    func setupListItemTableView(){
        let listCellNib = UINib(nibName: "ListItemCell", bundle: nil)
        itemsTableView.register(listCellNib, forCellReuseIdentifier: "ListItemCell")
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        setupRefreshControl()
    }
}

extension ShowListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayedList?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedList?.categories[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureListItemCell(indexPath: indexPath)
    }
    
    func configureListItemCell(indexPath: IndexPath) -> ListItemCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        
        if let item = displayedList?.categories[indexPath.section].items[indexPath.row] {
            cell.item = item
            cell.configureUI()
        }

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}

extension ShowListViewController {
    func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshItems), for: .valueChanged)
        itemsTableView.addSubview(refreshControl)
    }
    
    @objc func refreshItems(){
        getList()
    }
}

extension ShowListViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = itemsTableView.dequeueReusableHeaderFooterView(withIdentifier:  "ListSectionHeader") as! ListSectionHeader

        let categoryName = displayedList!.categories[section].name
        header.headingLabel.text = categoryName
        
        return header
    }

}

extension ShowListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, completionHandler) in
            self.deleteListItemPressed(indexPath: indexPath)
            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteListItemPressed(indexPath: IndexPath){
        if displayedList!.categories[indexPath.section].items.count == 1 {
            let indexSet = NSIndexSet(index: indexPath.section)
            displayedList!.categories.remove(at: indexPath.section)
            itemsTableView.deleteSections(indexSet as IndexSet, with: .left)
        } else {
            displayedList!.categories[indexPath.section].items.remove(at: indexPath.row)
            itemsTableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension ShowListViewController {
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
}
