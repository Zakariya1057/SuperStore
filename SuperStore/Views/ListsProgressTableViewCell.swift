//
//  ListPriceUpdateTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListsProgressElement: CustomElementModel {
    var title: String
    var type: CustomElementType { return .listsProgress }
    var delegate: ShowListDelegate
    var height: Float
    
    init(title: String,delegate: ShowListDelegate,height:Float) {
        self.title = title
        self.delegate = delegate
        self.height = height
    }
}

class ListsProgressTableViewCell: UITableViewCell,CustomElementCell {

    var model: ListsProgressElement!
    
    @IBOutlet weak var listViewButton: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ListsProgressElement else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {

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
