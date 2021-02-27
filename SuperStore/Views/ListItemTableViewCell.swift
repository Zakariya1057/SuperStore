////
////  ListItemTableViewCell.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 30/07/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import UIKit
//
//class ListItemTableViewCell: UITableViewCell {
//    
//    var tickedOff:Bool = false
//    
//    @IBOutlet weak var totalLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet var nameView: UIView!
//    @IBOutlet weak var tickBoxButton: UIButton!
//    
//    var listManager: ListManager = ListManager()
//    
//    var loadingViews: [UIView] {
//        return [nameLabel,tickBoxButton,totalLabel]
//    }
//
//    var product: ListItemModel?
//    
//    var delegate: PriceChangeDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    func configureUI(){
//        
//        stopLoading()
//        
//        let currentProduct = product!
//        
//        var name: String = currentProduct.name
//            
//        if currentProduct.weight != nil {
//            name += " (\(currentProduct.weight!))"
//        }
//        
//        nameLabel.attributedText =
//            NSMutableAttributedString()
//                .bold(String(product!.quantity))
//                .normal(" x " + name)
//        
//        tickedOff = currentProduct.tickedOff
//        showCheckBox()
//        showPriceTotal()
//        
//    }
//    
//    @IBAction func checkBoxPressed(_ sender: UIButton) {
//        tickedOff = !tickedOff
//        product!.tickedOff = tickedOff
//        delegate!.productChanged(product!)
//        
//        showCheckBox()
//    }
//    
//    func setQuantity(_ quantity:Int){
//        product?.quantity = quantity
//        showPriceTotal()
//    }
//    
//    func showPriceTotal(){
//        let totalText = "£" + String(format: "%.2f", listManager.calculateProductPrice(product!))
//        totalLabel.text = "\(totalText)"
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
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
//    
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
//    
//}
