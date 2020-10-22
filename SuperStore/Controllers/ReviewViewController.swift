//
//  ReviewViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

class ReviewViewController: UIViewController, ReviewsListDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
//    var product: ProductDetailsModel?
    
    var product_id: Int?
    
    var product: ProductHistory? {
        get {
            return realm.objects(ProductHistory.self).filter("id = \(product_id!)").first
        }
    }
    
    @IBOutlet var deleteButton: UIButton!
    var userSession = UserSession()
    
    var user_id: Int {
        return userSession.getUserDetails()!.id
    }
    
    let realm = try! Realm()
    
    var review: ReviewHistory? {
        get {
            return realm.objects(ReviewHistory.self).filter("product_id = \(product!.id) AND user_id = \(user_id)").first
        }
    }

    @IBOutlet weak var reviewTitleView: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    var reviewHandler = ReviewsHandler()
    
    var requestSent: Bool = false
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewHandler.delegate = self
        reviewTitleView.delegate = self
        reviewTextView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.

//        reviewTextView.layer.cornerRadius = 5
        reviewTitleView!.layer.borderWidth = 0
//        reviewTitleView!.layer.borderColor = CGColor(srgbRed: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        
        reviewTextView.layer.cornerRadius = 5
//        reviewTextView.layer.borderWidth = 1
//        reviewTextView.layer.borderColor = CGColor(srgbRed: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        
        reviewTextView.toolbarPlaceholder = "Review Text"
       
        reviewHandler.delegate = self
        reviewHandler.show(product_id: product!.id)
        
        nameLabel.text = product!.name
        imageView.downloaded(from: product!.image)
        
        if review != nil {
            configureUI()
        }
    }
    
    func contentLoaded(reviews: [ReviewModel]) {
        stopLoading()
        
        if reviews.count > 0 {
            addToHistory(reviews[0])
            configureUI()
        }
        
        if requestSent {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 55
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textFieldText = textView.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        return count <= 1500
    }
    
    func configureUI(){
        reviewTitleView.text = review!.title
        reviewTextView.text = review!.text
        ratingView.rating = Double(review!.rating)
        deleteButton.alpha = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reviewPressed(_ sender: Any) {
        // Validate first, are all fields filled up. -> Later
        
        
        let text = String(reviewTextView.text ?? "")
        let title = String(reviewTitleView.text ?? "")
        let rating = String(ratingView.rating)
        
        if text == "" {
            return showError("Review text required.")
        }
        
        if title == "" {
            return showError("Review title required.")
        }
        
        requestSent = true
        
        startLoading()
    
        reviewHandler.create(product_id: product!.id, review_data: [
            "rating": rating,
            "title": title,
            "text": text
        ])
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        confirmDelete()
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Deleting Review?", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.requestSent = true
            
            try! self.realm.write() {
                self.realm.delete(self.review!)
            }
            
            self.reviewHandler.delete(product_id: self.product!.id)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Review Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
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

extension ReviewViewController {
    func addToHistory(_ productReview: ReviewModel){
    
        let reviewItem = realm.objects(ReviewHistory.self).filter("id = \(productReview.id) AND product_id = \(product!.id) AND user_id = \(productReview.user_id)").first
        
        try! realm.write() {
            if reviewItem == nil {
                print("Add To Item")
                product!.reviews.append(productReview.getRealmObject())
            } else {
                reviewItem!.title = productReview.title
                reviewItem!.rating = productReview.rating
                reviewItem!.text = productReview.text
                reviewItem!.updated_at = Date()
            }
            
            let productReviews = realm.objects(ReviewHistory.self).filter("product_id = \(product!.id)")
            product!.totalReviewsCount = productReviews.count
            
            var totalRating = 0
            for reviewItem in productReviews {
                totalRating = totalRating + reviewItem.rating
            }
            
            product!.avgRating = Double(totalRating) / Double(productReviews.count)
        }
        
    }
    
}
