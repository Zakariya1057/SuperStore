//
//  Choose your custom row height     } ListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListItemViewController: UIViewController {
    
    var product: ListItemModel?
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var delegate: ProductQuantityChangedDelegate?
    
    var selected_row: Int = 0
    var selected_section: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        stepper.value = Double(quantity)
        quantityLabel.text = String(quantity)
        product!.quantity = quantity
        updateTotalPrice()
    }
    
    func configureUI(){
        quantityLabel.text = String(product!.quantity)
        productNameLabel.text = String(product!.name) + " (\(product!.weight ?? ""))"
        stepper.value = Double(product!.quantity)
        productImageView.downloaded(from: product!.image)
        updateTotalPrice()
    }
    
    func updateTotalPrice(){
        productTotalLabel.text = "£" + String(format: "%.2f", Double(product!.quantity) * product!.price)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
         self.delegate!.quantityChanged(section_index: selected_section, row_index: selected_row, quantity: product!.quantity)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.delegate!.removeItem(section: selected_section, row: selected_row)
        self.navigationController?.popViewController(animated: true)
    }
    
}
