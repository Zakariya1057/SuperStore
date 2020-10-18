//
//  ProductReviewsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewsListDelegate {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    let realm = try! Realm()
    
    var reviews: Results<ReviewHistory> {
        get {
            return realm.objects(ReviewHistory.self).filter("product_id = \(product_id)").sorted(byKeyPath: "updated_at", ascending: false)
        }
    }
    
//    var reviews:[ReviewModel] = []
    
    var reviewsHandler = ReviewsHandler()
    
    var product_id: Int = 1
    
    var loading:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        
        reviewsHandler.delegate = self
        reviewsHandler.index(product_id: product_id)
        
        if reviews.count > 0 {
            loading = false
            reviewsTableView.reloadData()
        }
        
         reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func contentLoaded(reviews: [ReviewModel]) {

        for review in reviews {
            addToHistory(review)
        }
        
        loading = false
        reviewsTableView.reloadData()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        self.reviewsTableView.reloadData()
        showError(message)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count == 0 && loading == true ? 3 : reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
        
        if loading == false {
            cell.review = reviews[indexPath.row].getReviewModel()
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Reviews Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}

extension ReviewsViewController {
    func addToHistory(_ review: ReviewModel){
    
        var reviewItem = realm.objects(ReviewHistory.self).filter("product_id = \(product_id) AND id = \(review.id)").first
        
        try! realm.write() {
            if reviewItem == nil {
                let reviewObject = review.getRealmObject()
                realm.add(reviewObject)
            } else {
                reviewItem! = review.getRealmObject()
            }
            
        }
        
        
    }
    
}
