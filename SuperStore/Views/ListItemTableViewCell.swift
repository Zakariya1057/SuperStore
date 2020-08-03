//
//  ListItemTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {
    
    var ticked:Bool = false
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var productIndex: Int = 0
    
    var product: ListProductModel?
    
    var delegate:PriceChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var tickBoxButton: UIButton!
    
    func configureUI(){
        let currentProduct = product!
        
        print("Configure UI: \(currentProduct.name)")
        priceLabel.text = "£" + String(format:"%.2f", currentProduct.price)
        nameLabel.text = currentProduct.name
        locationLabel.text = currentProduct.location ?? ""
        setQuantity(currentProduct.quantity)
        
        ticked = currentProduct.ticked
        showCheckBox()
    }
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        ticked = !ticked
        product!.ticked = ticked
        reflectChange()
        showCheckBox()
    }
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        setQuantity(Int(sender.value))
        reflectChange()
    }
    
    func setQuantity(_ quantity:Int){
        stepper.value = Double(quantity)
        product?.quantity = quantity
        quantityLabel.text = String(quantity)
    }
    
    func showCheckBox(){
        if !ticked {
            tickBoxButton.tintColor = .label
            tickBoxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            tickBoxButton.tintColor = UIColor(named: "LogoBlue")
            tickBoxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reflectChange(){
        delegate!.productChanged(product: product!, index: productIndex)
    }
    
}
