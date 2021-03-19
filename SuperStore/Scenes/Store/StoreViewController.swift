//
//  StoreViewController.swift
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

protocol StoreDisplayLogic: class
{
    func displayStore(viewModel: Store.GetStore.ViewModel)
}

class StoreViewController: UIViewController, StoreDisplayLogic
{
    var interactor: StoreBusinessLogic?
    var router: (NSObjectProtocol & StoreRoutingLogic & StoreDataPassing)?
    
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
        let interactor = StoreInteractor()
        let presenter = StorePresenter()
        let router = StoreRouter()
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
        
        setUpHoursTable()
        setupFeaturesTable()
       
        displayRightBarButton()
        startLoading()
        getStore()
    }
    
    @IBOutlet weak var facilitiesTableView: UITableView!
    @IBOutlet weak var hoursTableView: UITableView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet var loadingViews: [UIView]!
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }
    
    var hours: [Store.DisplayOpeningHour] = []
    var facilities: [Store.DisplayFacility] = []
    
    func getStore()
    {
        let request = Store.GetStore.Request()
        interactor?.getStore(request: request)
    }
    
    func displayStore(viewModel: Store.GetStore.ViewModel)
    {
        if let error = viewModel.error, !viewModel.offline {
            showError(title: "Store Error", error: error)
        } else {
            if let store = viewModel.displayedStore {
                
                loading = false
                
                nameLabel.text = store.name
                addressLabel.text = store.address
                
                if let image = store.logoImage {
                    logoImageView.image = image
                } else {
                    logoImageView.downloaded(from: store.logo)
                }
                
                hours = store.openingHours
                hoursTableView.reloadData()
                
                facilities = store.facilities
                facilitiesTableView.reloadData()
            }
        }
        
    }
    
    func displayRightBarButton(){
        if interactor?.selectedListID == nil {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

}


extension StoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 7 : tableView == facilitiesTableView ? facilities.count : hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hoursTableView {
            return configureHourCell(indexPath: indexPath)
        } else {
            return configureFacilityCell(indexPath: indexPath)
        }
    }
    
    func configureFacilityCell(indexPath: IndexPath) -> FacilityTableViewCell {
        let cell = facilitiesTableView.dequeueReusableCell(withIdentifier: "FacilityTableViewCell", for: indexPath) as! FacilityTableViewCell

        cell.loading = loading
        
        if !loading {
            cell.facility = facilities[indexPath.row]
            cell.configureUI()
        }

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func configureHourCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = hoursTableView.dequeueReusableCell(withIdentifier: "OpeningHourTableViewCell", for: indexPath) as! OpeningHourTableViewCell
        
        cell.loading = loading
        
        if !loading {
            
            let hour = hours[indexPath.row]
            
            cell.dayLabel.text = hour.day
            cell.hourLabel.text = hour.hours
            
            if hour.today {
                if hour.closedToday {
                    cell.dayLabel.textColor = .systemRed
                    cell.hourLabel.textColor = .systemRed
                } else {
                    cell.dayLabel.textColor = .systemBlue
                    cell.hourLabel.textColor = .systemBlue
                }
            } else {
                cell.dayLabel.textColor = .label
                cell.hourLabel.textColor = .label
            }
            
        }

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func setupFeaturesTable(){
        let featureCellNib = UINib(nibName: "FacilityTableViewCell", bundle: nil)
        facilitiesTableView.register(featureCellNib, forCellReuseIdentifier: "FacilityTableViewCell")
        
        facilitiesTableView.separatorStyle = .none
        facilitiesTableView.delegate = self
        facilitiesTableView.dataSource = self
    }
    
    func setUpHoursTable(){
        let featureCellNib = UINib(nibName: "OpeningHourTableViewCell", bundle: nil)
        hoursTableView.register(featureCellNib, forCellReuseIdentifier: "OpeningHourTableViewCell")
        
        hoursTableView.separatorStyle = .none
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
    }
}

extension StoreViewController {
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        router?.routeToShowList(segue: nil)
    }
}

extension StoreViewController {
    func startLoading(){
        for item in loadingViews {
            item.isSkeletonable = true
            item.showAnimatedGradientSkeleton()
        }
    }
    
    func stopLoading(){
        for item in loadingViews {
            item.hideSkeleton()
        }
    }
}

