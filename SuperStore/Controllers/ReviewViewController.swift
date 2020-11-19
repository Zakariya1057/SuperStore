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

    @IBOutlet var saveBarItem: UIBarButtonItem!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reviewTitleView: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    var productID: Int?
    
    var product: ProductHistory? {
        get {
            return realm.objects(ProductHistory.self).filter("id = \(productID!)").first
        }
    }
    
    var offline: Bool {
        return RequestHandler.sharedInstance.offline
    }
    
    @IBOutlet var deleteButton: UIButton!
    var userSession = UserSession()
    
    var user_id: Int {
        return userSession.getUserDetails()!.id
    }
    
    let realm = try! Realm()
    
    var review: ReviewHistory? {
        get {
            return realm.objects(ReviewHistory.self).filter("productID = \(product!.id) AND userID = \(user_id)").first
        }
    }

    var reviewHandler = ReviewsHandler()
    
    var requestSent: Bool = false
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    var userHandler = UserHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewHandler.delegate = self
        reviewTitleView.delegate = self
        reviewTextView.delegate = self

        reviewTitleView!.layer.borderWidth = 0
        reviewTextView.layer.cornerRadius = 5
        
        reviewTextView.toolbarPlaceholder = "Review Text"
       
        reviewHandler.delegate = self
        reviewHandler.show(productID: product!.id)
        
        nameLabel.text = product!.name
        imageView.downloaded(from: product!.largeImage)
        
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
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
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
    }
    
    @IBAction func reviewPressed(_ sender: Any) {
        
        if offline {
            return showError("Internet connection required.")
        }
        
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
    
        reviewHandler.create(productID: product!.id, reviewData: [
            "rating": rating,
            "title": title,
            "text": text
        ])
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        
        if offline {
            return showError("Internet connection required.")
        }
        
        confirmDelete()
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Deleting Review?", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.requestSent = true
            
            try! self.realm.write() {
                self.realm.delete(self.review!)
            }
            
            self.reviewHandler.delete(productID: self.product!.id)
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
        saveBarItem.isEnabled = false
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        saveBarItem.isEnabled = true
    }

}

extension ReviewViewController {
    func addToHistory(_ productReview: ReviewModel){
    
        let reviewItem = realm.objects(ReviewHistory.self).filter("id = \(productReview.id) AND productID = \(product!.id) AND userID = \(productReview.userID)").first
        
        try! realm.write() {
            if reviewItem == nil {
                product!.reviews.append(productReview.getRealmObject())
            } else {
                reviewItem!.title = productReview.title
                reviewItem!.rating = productReview.rating
                reviewItem!.text = productReview.text
                reviewItem!.updatedAt = Date()
            }
            
            let productReviews = realm.objects(ReviewHistory.self).filter("productID = \(product!.id)")
            product!.totalReviewsCount = productReviews.count
            
            var totalRating = 0
            for reviewItem in productReviews {
                totalRating = totalRating + reviewItem.rating
            }
            
            product!.avgRating = Double(totalRating) / Double(productReviews.count)
        }
        
    }
    
}
