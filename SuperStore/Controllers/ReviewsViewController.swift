//
//  ProductReviewsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    let reviews = ["First Review","Second Review","Third Review"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        
         reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
