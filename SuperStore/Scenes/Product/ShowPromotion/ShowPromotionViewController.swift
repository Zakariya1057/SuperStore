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

protocol ShowPromotionDisplayLogic: class
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
    @IBOutlet var promotionTableView: UITableView!
    
    @IBOutlet var promotionExpiryView: UIView!
    @IBOutlet var promotionExpiresLabel: UILabel!
    
    @IBOutlet var promotionNameLabel: UILabel!
    @IBOutlet var promotionNameView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTableView()
        getPromotion()
    }
    
    var loading: Bool = false
    var promotion: PromotionModel? = nil
    
    func getPromotion()
    {
        let request = ShowPromotion.GetPromotion.Request()
        interactor?.getPromotion(request: request)
    }
    
    func displayPromotion(viewModel: ShowPromotion.GetPromotion.ViewModel)
    {
        promotion = viewModel.promotion
        print(promotion!.products)
        promotionTableView.reloadData()
    }
}

extension ShowPromotionViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView(){
        promotionTableView.delegate = self
        promotionTableView.dataSource = self
        
        registerReviewsTableView()
    }
    
    func registerReviewsTableView(){
        let promotionCellNib = UINib(nibName: "ProductCell", bundle: nil)
        promotionTableView.register(promotionCellNib, forCellReuseIdentifier: "ProductCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotion?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = promotionTableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

        if loading == false {
            
            if let promotion = promotion {
                cell.product = promotion.products[indexPath.row]
            }
            
//            cell.product = products[indexPath.row]
//
//            if self.delegate != nil {
//                cell.delegate = self.delegate
//            }
//
//            cell.hideAll = true

            cell.configureUI()
        } else {
            cell.startLoading()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
}
