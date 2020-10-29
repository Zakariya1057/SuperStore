//
//  ListTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var loading: Bool = true
    
    var list: ListModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var loadingViews: [UIView] {
        return [listNameLabel, totalLabel,createdLabel,statusLabel]
    }
    
    func configureUI(){
        
        loading ? startLoading() : stopLoading()
        
        if list != nil {
            
//            stopLoading()
            
            let status = list!.status
            
            listNameLabel.text = list!.name
            totalLabel.text = "£\( String(format:"%.2f", list!.totalPrice))"
           

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM Y"
            let date = dateFormatter.string(from: list!.created_at)
            
            createdLabel.text = date
            
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
