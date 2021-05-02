//
//  ListPriceUpdateTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListPriceUpdateGroupElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .products
    var items: [HomeElementItemModel]
    var loading: Bool = true
    var showViewAllButton: Bool = false
    
    init(title: String, stores: [ListPriceUpdateElementModel]) {
        self.title = title
        self.items = stores
    }
}

class ListPriceUpdateElementModel: HomeElementItemModel {
    var loading: Bool = true
}

class ListPriceUpdateTableViewCell: UITableViewCell, HomeElementCell {

    var model: ListPriceUpdateElementModel!
    
    @IBOutlet weak var listViewButton: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var loading: Bool = true
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? ListPriceUpdateElementModel else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        
//        self.loading = model.loading
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showListsPage))
        listViewButton.addGestureRecognizer(gesture)
    }
    
    @objc func showListsPage(){
//        self.model.delegate.showListPage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
