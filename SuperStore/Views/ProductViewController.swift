//
//  ProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class ProductViewController: UIViewController, ProductDelegate,ProductDetailsDelegate {

    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var allReviewsView: UIView!
    
    @IBOutlet weak var allReviewsButton: UIButton!
    
    @IBOutlet weak var dietaryView: UIStackView!
    @IBOutlet weak var allergenView: UIStackView!
    @IBOutlet weak var promotionView: UIView!
//    @IBOutlet weak var promotionExpiryView: UIView!
    
    //Field Labels
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productWeightLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var lifeStyleLabel: UILabel!
    @IBOutlet weak var allergenLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
//    @IBOutlet weak var promotionExpiryLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    //
    
    @IBOutlet weak var reviewsTableView: UITableView!
    var product: ProductDetailsModel?
    
    var details_type: String = ""
    
    var productHandler = ProductDetailsHandler()
    
    var product_id:Int = 1
    
    @IBOutlet weak var similarTableView: UITableView!
    
    var similarProducts = ["Item 1","Item 2","Item 3","Item 4","Item 5"]
    
    var reviews: [ReviewModel] = []
    var recommended: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
        productHandler.delegate = self
        productHandler.request(product_id: product_id)

        similarTableView.delegate = self
        similarTableView.dataSource = self
        
        similarTableView.rowHeight = 280;
        
        let ingredients_gesture = UITapGestureRecognizer(target: self, action: #selector(showIngredients))
        ingredientsView.addGestureRecognizer(ingredients_gesture)
        
        let description_gesture = UITapGestureRecognizer(target: self, action: #selector(showDescription))
        descriptionView.addGestureRecognizer(description_gesture)
        
        let promotion_gesture = UITapGestureRecognizer(target: self, action: #selector(showPromotion))
        promotionView.addGestureRecognizer(promotion_gesture)
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
    }
    
    func contentLoaded(product: ProductDetailsModel) {
        self.product = product
        
        productNameLabel.text = product.name
        productWeightLabel.text = product.weight
        
        productPriceLabel.text = "£" + String(format: "%.2f", product.price)
        productImageView.downloaded(from: product.image)
        
        ratingView.rating = product.avg_rating!
        ratingView.text = "(\(product.total_reviews_count!))"
        
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
        }

    }
    
}

extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.review = reviews[0]
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }

    }
    
    func showProduct(product_id: Int) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        vc.product_id = product_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


