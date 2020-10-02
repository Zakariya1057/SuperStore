//
//  ProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class ProductViewController: UIViewController, ProductDelegate,ProductDetailsDelegate, FavouritesDelegate {

    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var allReviewsView: UIView!
    
    @IBOutlet weak var allReviewsButton: UIButton!
    
    @IBOutlet weak var dietaryView: UIStackView!
    @IBOutlet weak var allergenView: UIStackView!
    @IBOutlet weak var promotionView: UIView!
//    @IBOutlet weak var promotionExpiryView: UIView!
    @IBOutlet weak var favouriteBarItem: UIBarButtonItem!
    
    //Field Labels
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productWeightLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var lifeStyleLabel: UILabel!
    @IBOutlet weak var allergenLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
//    @IBOutlet weak var promotionExpiryLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var parentRatingView: UIView!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    var product: ProductDetailsModel?
    
    var details_type: String = ""
    
    var productHandler = ProductDetailsHandler()
    
    var product_id:Int = 1
    
    @IBOutlet weak var monitorButton: UIButton!
    @IBOutlet weak var similarTableView: UITableView!
    @IBOutlet weak var addToListButton: UIButton!
    
    var reviews: [ReviewModel] = []
    var recommended: [ProductModel] = []
    
    var favouritesHandler = FavouritesHandler()
    
    var loadingViews: [UIView] {
        return [productNameLabel,descriptionView,ingredientsView, reviewButton,productImageView,productPriceLabel,productWeightLabel,parentRatingView,addToListButton,monitorButton,allReviewsButton, allergenLabel,promotionView,lifeStyleLabel]
    }
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
        productHandler.delegate = self
        favouritesHandler.delegate = self
        productHandler.request(product_id: product_id)

        similarTableView.delegate = self
        similarTableView.dataSource = self
        
        let ingredients_gesture = UITapGestureRecognizer(target: self, action: #selector(showIngredients))
        ingredientsView.addGestureRecognizer(ingredients_gesture)
        
        let description_gesture = UITapGestureRecognizer(target: self, action: #selector(showDescription))
        descriptionView.addGestureRecognizer(description_gesture)
        
        let promotion_gesture = UITapGestureRecognizer(target: self, action: #selector(showPromotion))
        promotionView.addGestureRecognizer(promotion_gesture)
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
        
        startLoading()
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }
    
    func contentLoaded(product: ProductDetailsModel) {
        self.product = product
        
        loading = false
        stopLoading()
        
        productNameLabel.text = product.name
        productWeightLabel.text = product.weight

        productPriceLabel.text = "£" + String(format: "%.2f", product.price)
        productImageView.downloaded(from: product.image)

        ratingView.rating = product.avg_rating!
        ratingView.text = "(\(product.total_reviews_count!))"

        showFavourite()

        if(product.dietary_info == nil || product.dietary_info == ""){
            dietaryView.removeFromSuperview()
        } else {
            lifeStyleLabel.text = product.dietary_info
        }

        if(product.allergen_info == nil || product.allergen_info == ""){
            allergenView.removeFromSuperview()
        } else {
            allergenLabel.text = product.allergen_info
        }

        if(product.promotion == nil){
            promotionView.removeFromSuperview()
        } else {
            let promotion = product.promotion!
            promotionLabel.text = promotion.name
        }

        reviews = product.reviews
        let review_count = reviews.count

        if review_count != 0 {
            reviewsTableView.reloadData()
            allReviewsButton.setTitle("View All Reviews", for: .normal)
        } else {
            allReviewsButton.removeFromSuperview()
            reviewsStackView.removeFromSuperview()
        }

        if product.recommended.count > 0 {
            recommended = product.recommended
            similarTableView.reloadData()
        }
        
    }
    
    func contentLoaded(products: [ProductModel]) {
    }
    
    @objc func showIngredients(){
        details_type = "ingredients"
        self.performSegue(withIdentifier: "showProductDetails", sender: self)
    }
    
    @objc func showDescription(){
        details_type = "description"
        self.performSegue(withIdentifier: "showProductDetails", sender: self)
    }
    
    @objc func showPromotion(){
        self.performSegue(withIdentifier: "showProductPromotion", sender: self)
    }
    
    @IBAction func favouritePressed(_ sender: Any) {
        
        if product == nil {
            return
        }
        
        product!.favourite = !product!.favourite
        favouritesHandler.update(product_id: product_id, favourite: product!.favourite)
        showFavourite()
    }
    
    func showFavourite(){
        
        let barItem:UIBarButtonItem
        
        if product!.favourite == true {
            barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouritePressed))
            barItem.image = UIImage(systemName: "star.fill")
        } else {
            barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouritePressed))
            barItem.image = UIImage(systemName: "star")
        }
        
        barItem.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "showProductDetails" {
            
            let destinationVC = segue.destination as! ProductDetailsViewController
            
            if(details_type == "ingredients"){
                destinationVC.header_text = "Ingredients"
                destinationVC.list = product!.ingredients
            } else if(details_type == "description"){
                destinationVC.header_text = "Description"
                destinationVC.list = [ product!.description ?? "" ]
            }
            
        } else if segue.identifier == "productToReviews" {
            let destinationVC = segue.destination as! ReviewsViewController
            destinationVC.product_id = product_id
        }  else if segue.identifier == "showProductPromotion" {
            let destinationVC = segue.destination as! PromotionViewController
            destinationVC.promotion_id = product!.promotion!.id
        } else if segue.identifier == "productToCreateReview" {
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.product = product!
        }

    }
    
}

extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading == true {
            return 1
        }
        
        if tableView == similarTableView {
            return 1
        } else {
            return reviews.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == similarTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.ProductCell.CellIdentifier, for: indexPath) as! ProductTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.configure(withModel: ProductElement(title: "Products You May Like", delegate: self, products: recommended, height: 200))
//            cell.model.title = "Products You May Like"
//            cell.model.products = recommended
//            cell.delegate = self
//            cell.configureUI()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
            
            if loading == false {
                cell.review = reviews[0]
                cell.configureUI()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            } else {
                cell.startLoading()
            }

            return cell
        }

    }
    
    func showProduct(product_id: Int) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        vc.product_id = product_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Product Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}


