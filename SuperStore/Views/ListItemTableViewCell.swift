//
//  ListItemTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {
    
    var ticked_off:Bool = false
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tickBoxButton: UIButton!
    
    var listManager: ListManager = ListManager()
    
    var loadingViews: [UIView] {
        return [nameLabel,tickBoxButton,tickBoxButton,totalLabel]
    }
    
    var productIndex: Int = 0

    var product: ListItemModel?
    
    var delegate:PriceChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(){
        
        stopLoading()
        
        let currentProduct = product!
        
        nameLabel.attributedText =
            NSMutableAttributedString()
                .bold(String(product!.quantity))
                .normal(" x " + currentProduct.name)
        
        ticked_off = currentProduct.ticked_off
        showCheckBox()
        showPriceTotal()
        
    }
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        ticked_off = !ticked_off
        product!.ticked_off = ticked_off
        delegate!.productChanged(product!)
        
        showCheckBox()
    }
    
    func setQuantity(_ quantity:Int){
        product?.quantity = quantity
        showPriceTotal()
    }
    
    func showPriceTotal(){
        let totalText = "£" + String(format: "%.2f", listManager.calculateProductPrice(product!))
        totalLabel.text = "\(totalText)"
    }
    
    func showCheckBox(){
        if !ticked_off {
            tickBoxButton.tintColor = .label
            tickBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            tickBoxButton.tintColor = UIColor(named: "LogoBlue")
            tickBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
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
