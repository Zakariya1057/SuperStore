//
//  ReviewViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController, ReviewsListDelegate {

    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    var product: ProductDetailsModel?
    var review: ReviewModel?
    

    @IBOutlet weak var reviewTitleView: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    var reviewHandler = ReviewsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//       reviewTitleView!.layer.borderWidth = 1
//        reviewTitleView!.layer.borderColor = CGColor(srgbRed:0.90, green: 0.90, blue: 0.90, alpha: 1)

//        reviewTextView!.layer.borderWidth = 1
//        reviewTextView!.layer.borderColor = CGColor(srgbRed:0.90, green: 0.90, blue: 0.90, alpha: 1)
        
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = CGColor(srgbRed: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        
       
        reviewHandler.delegate = self
        reviewHandler.show(product_id: product!.id)
        
        nameLabel.text = product!.name
        imageView.downloaded(from: product!.image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contentLoaded(reviews: [ReviewModel]) {
        if reviews.count > 0 {
            self.review = reviews[0]
            configureUI()
        }
        
    }
    
    func configureUI(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        reviewTitleView.text = review!.title
        reviewTextView.text = review!.text
        ratingView.rating = Double(review!.rating)
    }
    
    @IBAction func reviewPressed(_ sender: Any) {
        // Validate first, are all fields filled up. -> Later
        
        let text = String(reviewTextView.text)
        let title = String(reviewTitleView.text ?? "")
        let rating = String(ratingView.rating)
        
        reviewHandler.create(product_id: product!.id, review_data: [
            "rating": rating,
            "title": title,
            "text": text
        ])
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        reviewHandler.delete(product_id: product!.id)
        self.navigationController?.popViewController(animated: true)
    }
}
