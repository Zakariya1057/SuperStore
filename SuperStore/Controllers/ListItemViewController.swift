//
//  Choose your custom row height     } ListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListItemViewController: UIViewController {
    
    var product: ListProductModel?
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var delegate: ProductQuantityChangedDelegate?
    
    var product_index: Int = 0
    
    var quantity: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        quantity = Int(sender.value)
        stepper.value = Double(quantity)
        quantityLabel.text = String(quantity)
        product!.quantity = quantity
        updateTotalPrice()
    }
    
    func configureUI(){
        if product != nil {
            quantityLabel.text = String(product!.quantity)
            productNameLabel.text = String(product!.name)
            stepper.value = Double(product!.quantity)
            productImageView.downloaded(from: product!.image)
            updateTotalPrice()
        }
    }
    
    func updateTotalPrice(){
        productTotalLabel.text = "£" + String(format: "%.2f", Double(product!.quantity) * product!.price)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.delegate!.quantityChanged(product_index: product_index, quantity: quantity)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
