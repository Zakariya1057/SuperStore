//
//  ListTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet var loadingViews: [UIView]!
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }

    var list: ListModel?
    
    var dateWorker = DateWorker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(){

        if let list = list {

            let status = list.status

            listNameLabel.text = list.name
            totalLabel.text = list.getTotalPrice()

            createdLabel.text = dateWorker.formatDate(date: list.updatedAt)

            if status == .notStarted {
                statusLabel.textColor =  UIColor(red: 0.44, green: 0.44, blue: 0.47, alpha: 1.00)
                statusLabel.text = "Not Started"
            } else if status == .inProgress {
                statusLabel.textColor =  UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.00)
                statusLabel.text = "In Progress"
            } else if status == .completed {
                statusLabel.textColor =  UIColor(named: "Green.Light")
                statusLabel.text = "Completed"
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension ListCell {
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
}
