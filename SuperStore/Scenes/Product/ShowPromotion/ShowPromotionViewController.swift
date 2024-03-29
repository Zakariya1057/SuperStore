//
//  ShowPromotionViewController.swift
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

protocol ShowPromotionDisplayLogic: AnyObject
{
    func displayPromotion(viewModel: ShowPromotion.GetPromotion.ViewModel)
}

class ShowPromotionViewController: UIViewController, ShowPromotionDisplayLogic
{
    var interactor: ShowPromotionBusinessLogic?
    var router: (NSObjectProtocol & ShowPromotionRoutingLogic & ShowPromotionDataPassing)?
    
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
        let interactor = ShowPromotionInteractor()
        let presenter = ShowPromotionPresenter()
        let router = ShowPromotionRouter()
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
        getPromotion()
    }
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var promotionTableView: UITableView!
    
    @IBOutlet weak var expiresStackView: UIStackView!
    @IBOutlet var promotionExpiryView: UIView!
    @IBOutlet var promotionExpiresLabel: UILabel!
    
    var loading: Bool = true
    var products: [ProductModel] = []
    
    func getPromotion()
    {
        let request = ShowPromotion.GetPromotion.Request()
        interactor?.getPromotion(request: request)
    }
    
    func displayPromotion(viewModel: ShowPromotion.GetPromotion.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            if !viewModel.offline {
                showError(title: "Promotion Error", error: error)
            }
        } else {
            
            if let promotion = viewModel.displayedPromotion {
                title = promotion.name
                expiresStackView.isHidden = !promotion.expires
                
                products = promotion.products
                
                if promotion.expires, let endsAt = promotion.endsAt {
                    promotionExpiresLabel.text = "Expires: \(endsAt)"
                }
                
                loading = false
                promotionTableView.reloadData()
            }
        }
    }
}

extension ShowPromotionViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView(){
        promotionTableView.delegate = self
        promotionTableView.dataSource = self
        
        registerReviewsTableView()
        setupRefreshControl()
    }
    
    func registerReviewsTableView(){
        let promotionCellNib = UINib(nibName: "ProductCell", bundle: nil)
        promotionTableView.register(promotionCellNib, forCellReuseIdentifier: "ProductCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = promotionTableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

        cell.loading = loading
        
        cell.product = loading ? nil : products[indexPath.row]

        cell.configureUI()

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}

extension ShowPromotionViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loading {
            router?.selectedProductID = products[indexPath.row].id
            router?.routeToShowProduct(segue: nil)
        }
    }
}

extension ShowPromotionViewController {
    func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshPromotion), for: .valueChanged)
        promotionTableView.addSubview(refreshControl)
    }
    
    @objc func refreshPromotion(){
        getPromotion()
    }
}
