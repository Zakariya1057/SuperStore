//
//  ListItemTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
    
    //    var tickedOff:Bool = false
    //
    //    @IBOutlet weak var totalLabel: UILabel!
    //    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet var nameView: UIView!
    //    @IBOutlet weak var tickBoxButton: UIButton!
    //
    ////    var listManager: ListManager = ListManager()
    //
    //    var loadingViews: [UIView] {
    //        return [nameLabel,tickBoxButton,totalLabel]
    //    }
    //
    //    var item: ListItemModel!
    //
    ////    var delegate: PriceChangeDelegate?
    //
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //    }
    //
    //    func configureUI(){
    //
    //        stopLoading()
    //
    //        var name: String = item.name
    //
    //        if item.weight != nil {
    //            name += " (\(item.weight!))"
    //        }
    //
    //        nameLabel.attributedText =
    //            NSMutableAttributedString()
    //                .bold(String(item.quantity))
    //                .normal(" x " + name)
    //
    //        tickedOff = item.tickedOff
    //        showCheckBox()
    //        showPriceTotal()
    //
    //    }
    //
    //    @IBAction func checkBoxPressed(_ sender: UIButton) {
    //        tickedOff = !tickedOff
    ////        product!.tickedOff = tickedOff
    ////        delegate!.productChanged(product!)
    //
    //        showCheckBox()
    //    }
    //
    //    func setQuantity(_ quantity:Int){
    ////        product?.quantity = quantity
    //        showPriceTotal()
    //    }
    //
    //    func showPriceTotal(){
    ////        let totalText = "£" + String(format: "%.2f", listManager.calculateProductPrice(product!))
    ////        totalLabel.text = "\(totalText)"
    //    }
    //
    //    func showCheckBox(){
    //        if !tickedOff {
    //            tickBoxButton.tintColor = .label
    //            tickBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
    //        } else {
    //            tickBoxButton.tintColor = UIColor(named: "LogoBlue")
    //            tickBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    //        }
    //    }
    
    @IBOutlet var checkBoxButton: UIButton!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    var item: ShowList.DisplayedListItem!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI(){
        displayName()
        priceLabel.text = item.totalPrice
    }
    
    func displayName(){
        let name = item.name
        let quantity = String(item.quantity)
        
        nameLabel.attributedText = NSMutableAttributedString().bold(quantity).normal(" x " + name)
    }
    
    @IBAction func checkBoxButtonPressed(_ sender: UIButton) {
        item.tickedOff = !item.tickedOff
        showCheckBox()
    }
    
}

extension ListItemCell {
    func showCheckBox(){
        if item.tickedOff {
            checkBoxButton.tintColor = .label
            checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            checkBoxButton.tintColor = UIColor(named: "LogoBlue")
            checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
}

extension ListItemCell {
    //    func startLoading(){
    //        for item in loadingViews {
    //            item.isSkeletonable = true
    //            item.showAnimatedGradientSkeleton()
    //        }
    //    }
    //
    //    func stopLoading(){
    //        for item in loadingViews {
    //            item.hideSkeleton()
    //        }
    //    }
}
