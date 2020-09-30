//
//  ProductReviewsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewsListDelegate {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    var reviews:[ReviewModel] = []
    
    var reviewsHandler = ReviewsHandler()
    
    var product_id: Int = 1
    
    var loading:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        
        reviewsHandler.delegate = self
        reviewsHandler.index(product_id: product_id)
        
         reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count == 0 && loading == true ? 3 : reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
        
        if loading == false {
            cell.review = reviews[indexPath.row]
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }

    func contentLoaded(reviews: [ReviewModel]) {
        self.reviews = reviews
        loading = false
        reviewsTableView.reloadData()
    }

}
