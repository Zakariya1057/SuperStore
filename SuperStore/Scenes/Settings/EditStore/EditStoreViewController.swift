//
//  EditStoreViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditStoreDisplayLogic: AnyObject
{
    func displayUpdatedStore(viewModel: EditStore.UpdateStore.ViewModel)
    func displaySupermarketChains(viewModel: EditStore.GetSupermarketChains.ViewModel)
}

class EditStoreViewController: UIViewController, EditStoreDisplayLogic
{
    
    var interactor: EditStoreBusinessLogic?
    var router: (NSObjectProtocol & EditStoreRoutingLogic & EditStoreDataPassing)?
    
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
        let interactor = EditStoreInteractor()
        let presenter = EditStorePresenter()
        let router = EditStoreRouter()
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
        
        setupSupermarketChainsTableView()
        getSupermarketChains()
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet var supermarketChainTableView: UITableView!
    
    var selectedsupermarketChainID: Int = 1
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }
    
    var supermarketChains: [SupermarketChainModel] = []
    
    func displayUpdatedStore(viewModel: EditStore.UpdateStore.ViewModel)
    {
        stopLoading()
        
        if let error = viewModel.error {
            showError(title: "Store Change Error", error: error)
        } else {
            router?.routeToSettings(segue: nil)
        }
    }
    
    func displaySupermarketChains(viewModel: EditStore.GetSupermarketChains.ViewModel) {
        selectedsupermarketChainID = viewModel.selectedsupermarketChainID
        supermarketChains = viewModel.supermarketChains
        supermarketChainTableView.reloadData()
    }
    
    func getSupermarketChains(){
        let request = EditStore.GetSupermarketChains.Request()
        interactor?.getSupermarketChains(request: request)
    }
}

extension EditStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supermarketChains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureStoreTypeCell(indexPath: indexPath)
    }
    
    func configureStoreTypeCell(indexPath: IndexPath) -> StoreTypeCell {
        let cell = supermarketChainTableView.dequeueReusableCell(withIdentifier: "StoreTypeCell", for: indexPath) as! StoreTypeCell
        
        let supermarketChain = supermarketChains[indexPath.row]
        
        cell.selectedSupermarketChain = supermarketChain.id == selectedsupermarketChainID
        cell.supermarketChain = supermarketChain
        
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func setupSupermarketChainsTableView(){
        let supermarketChainCellNib = UINib(nibName: "StoreTypeCell", bundle: nil)
        supermarketChainTableView.register(supermarketChainCellNib, forCellReuseIdentifier: "StoreTypeCell")
        
        supermarketChainTableView.delegate = self
        supermarketChainTableView.dataSource = self
    }
}

extension EditStoreViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let supermarketChain = supermarketChains[indexPath.row]
        supermarketChainSelected(supermarketChain: supermarketChain)
    }
    
    func supermarketChainSelected(supermarketChain: SupermarketChainModel){
        startLoading()

        let request = EditStore.UpdateStore.Request(supermarketChain: supermarketChain)
        interactor?.updateStore(request: request)
    }
}

extension EditStoreViewController {
    func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
