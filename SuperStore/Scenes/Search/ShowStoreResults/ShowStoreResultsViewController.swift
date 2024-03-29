//
//  ShowStoreResultsViewController.swift
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
import MapKit
import NotificationBannerSwift
import FloatingPanel

protocol ShowStoreResultsDisplayLogic: AnyObject
{
    func displayStores(viewModel: ShowStoreResults.GetStores.ViewModel)
}

class ShowStoreResultsViewController: UIViewController, ShowStoreResultsDisplayLogic
{
    var interactor: ShowStoreResultsBusinessLogic?
    var router: (NSObjectProtocol & ShowStoreResultsRoutingLogic & ShowStoreResultsDataPassing)?
    
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
        let interactor = ShowStoreResultsInteractor()
        let presenter = ShowStoreResultsPresenter()
        let router = ShowStoreResultsRouter()
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
        setupStoresTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    var fetchingStores: Bool = false
    
    var loading: Bool = true
    
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    var displayedStores: [ShowStoreResults.DisplayedStore] = []
    var stores: [StoreModel] = []
    
    var showingSlider: Bool = false
    
    @IBOutlet var mapTableView: UITableView!
    
    var storesViewController = StoresTableViewController()
    
    func getStores()
    {
        let request = ShowStoreResults.GetStores.Request(latitude: latitude, longitude: longitude)
        interactor?.getStores(request: request)
    }
    
    //MARK: - Display
    
    func displayRightBarButton(){
        if interactor?.selectedListID == nil {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func displayStores(viewModel: ShowStoreResults.GetStores.ViewModel)
    {
        if let error = viewModel.error {
            
            if !viewModel.offline {
                showError(title: "Store Errors", error: error)
            }
        } else {
            stores = viewModel.stores
            displayedStores = viewModel.displayedStore
            
            loading = false
            
            storesViewController.stores = stores
            storesViewController.displayedStores = displayedStores
            
            storesViewController.tableView.reloadData()
            
            setupSlider()
            
            mapTableView.reloadData()
        }
    }
    
    func setupSlider(){
        if showingSlider {
            return
        }
        // Initialize a `FloatingPanelController` object.
        let fpc = FloatingPanelController()

        // Set a content view controller.

        storesViewController.storePressed = storePressed
        fpc.set(contentViewController: storesViewController)

        // Track a scroll view(or the siblings) in the content view controller.
        fpc.track(scrollView: storesViewController.tableView)

        // Add and show the views managed by the `FloatingPanelController` object to self.view.
        fpc.addPanel(toParent: self)
        
        showingSlider = true
        
    }
}

extension ShowStoreResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureStoreMapCell(indexPath: indexPath)
    }
    
    func configureStoreMapCell(indexPath: IndexPath) -> StoresMapCell {
        let cell = mapTableView.dequeueReusableCell(withIdentifier: "StoresMapCell", for: indexPath) as! StoresMapCell

        cell.mapHeight.constant = mapTableView.frame.height
        cell.mapView.layoutIfNeeded()
        
        cell.storeHighlighted = storeMapHighlighted
        cell.storePressed = storePressed
        cell.userLocationFetched = userLocationFetched
        cell.stores = stores
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func setupStoresTableView(){
        
        let storesMapcellNib = UINib(nibName: "StoresMapCell", bundle: nil)
        mapTableView.register(storesMapcellNib, forCellReuseIdentifier: "StoresMapCell")
        
        mapTableView.delegate = self
        mapTableView.dataSource = self
    }
}

extension ShowStoreResultsViewController {
    private func userLocationFetched(location: CLLocationCoordinate2D?){
        if let location = location {
            longitude = Double(location.longitude)
            latitude = Double(location.latitude)
        } else {
            if !fetchingStores {
                let banner = StatusBarNotificationBanner(title: "Please allow Location Services from your Apple settings to view nearby stores.", style: .info)
                banner.dismissOnTap = true
                banner.dismissOnSwipeUp = true
                banner.show()
            }
        }

        if !fetchingStores {
            getStores()
            fetchingStores = true
        }
        
    }
}

extension ShowStoreResultsViewController {
    func storeMapHighlighted(storeID: Int){
        // Find the row with the selected store.
        // Scroll To that Row
        for (index, store) in stores.enumerated() {
            if store.id == storeID {
                storesViewController.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                break
            }
        }
    }
}

extension ShowStoreResultsViewController {
    func storePressed(storeID: Int){
        router?.selectedStoreID = storeID
        router?.routeToStore(segue: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        router?.routeToShowList(segue: nil)
    }
}
