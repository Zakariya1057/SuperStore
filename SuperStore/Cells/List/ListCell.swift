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

    var loading: Bool = false

    var list: ListModel?

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM Y"
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var loadingViews: [UIView] {
        return [listNameLabel, totalLabel,createdLabel,statusLabel]
    }

    func configureUI(){

        loading ? startLoading() : stopLoading()

        if list != nil {

            let status = list!.status

            listNameLabel.text = list!.name
            totalLabel.text = "£\( String(format:"%.2f", list!.totalPrice))"

            createdLabel.text = formatDate(date: list!.createdAt)

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
    
    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: list!.createdAt)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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

    
}
