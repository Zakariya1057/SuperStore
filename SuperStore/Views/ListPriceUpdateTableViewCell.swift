//
//  ListPriceUpdateTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListPriceUpdateElement: CustomElementModel {
    var title: String
    var type: CustomElementType { return .listPriceUpdate }
    var delegate: ShowListDelegate
    var position: CGFloat?
    
    init(title: String,delegate: ShowListDelegate) {
        self.title = title
        self.delegate = delegate
    }
}

protocol ShowListDelegate {
    func showListPage()
}

class ListPriceUpdateTableViewCell: UITableViewCell,CustomElementCell {

    var model: ListPriceUpdateElement!
    
    @IBOutlet weak var listViewButton: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ListPriceUpdateElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showListsPage))
        listViewButton.addGestureRecognizer(gesture)
    }
    
    @objc func showListsPage(){
        self.model.delegate.showListPage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
