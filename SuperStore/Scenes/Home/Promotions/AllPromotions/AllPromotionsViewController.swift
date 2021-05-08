//
//  AllPromotionsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AllPromotionsDisplayLogic: AnyObject
{
    func displayPromotions(viewModel: AllPromotions.GetAllPromotions.ViewModel)
}

class AllPromotionsViewController: UIViewController, AllPromotionsDisplayLogic
{
    var interactor: AllPromotionsBusinessLogic?
    var router: (NSObjectProtocol & AllPromotionsRoutingLogic & AllPromotionsDataPassing)?
    
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
        let interactor = AllPromotionsInteractor()
        let presenter = AllPromotionsPresenter()
        let router = AllPromotionsRouter()
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
        setupGroupsTableView()
        getPromotions()
    }
    
    var loading: Bool = true
    var promotionGroups: [PromotionGroupModel] = []
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var groupsTableView: UITableView!
    
    func getPromotions()
    {
        let request = AllPromotions.GetAllPromotions.Request()
        interactor?.getAllPromotions(request: request)
    }
    
    func displayPromotions(viewModel: AllPromotions.GetAllPromotions.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            if !viewModel.offline {
                showError(title: "Offers Error", error: error)
            }
        } else {
            loading = false
            promotionGroups = viewModel.promotionGroups
            groupsTableView.reloadData()
        }
    }
    
}

extension AllPromotionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 10 : promotionGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCategoryCell(indexPath: indexPath)
    }
    
    func configureCategoryCell(indexPath: IndexPath) -> CategoryTableViewCell {
        let cell = groupsTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell

        cell.nameLabel.text = loading ? "" : promotionGroups[indexPath.row].title

        cell.loading = loading
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func setupGroupsTableView(){
        let categoryCellNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        groupsTableView.register(categoryCellNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        setupRefreshControl()
    }
    
    func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshResults), for: .valueChanged)
        groupsTableView.addSubview(refreshControl)
    }
    
    @objc func refreshResults(){
        getPromotions()
    }
}

extension AllPromotionsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loading {
            let promotionGroup = promotionGroups[indexPath.row]
            interactor?.setPromotionSelected(promotionGroup: promotionGroup)
            
            router?.routeToPromotionGroup(segue: nil)
        }
    }
}
