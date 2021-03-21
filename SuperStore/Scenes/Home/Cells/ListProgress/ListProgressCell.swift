//
//  ListPriceUpdateTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListGroupProgressElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .listsProgress
    var items: [HomeElementItemModel]
    var listPressed: ((ListModel) -> Void)?
    var loading: Bool = true
    
    init(title: String, lists: [ListProgressElement], listPressed: @escaping (ListModel) -> Void) {
        self.title = title
        self.listPressed = listPressed
        self.items = lists
        
        configurePressed()
    }
    
    func setLoading(loading: Bool){
        self.loading = loading
        
        for item in items {
            item.loading = loading
        }
    }
    
    func configurePressed(){
        let lists = items as! [ListProgressElement]
        for list in lists {
            list.listPressed = listPressed
        }
    }
}

class ListProgressElement: HomeElementItemModel {
    var list: ListModel?
    var listPressed: ((ListModel) -> Void)?
    var loading: Bool = true
    
    init(list: ListModel?) {
        self.list = list
    }
}

class ListProgressCell: UITableViewCell, HomeElementCell {
    
    var model: ListProgressElement!
    
    var list: ListModel?
    
    var listPressed: ((ListModel) -> Void)?
    
    @IBOutlet var loadingViews: [UIView]!
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkMarkImage: UIImageView!
    @IBOutlet var tickedOffLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? ListProgressElement else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.list = model.list
        self.loading = model.loading
        
        displayList()
    }
    
    func displayList(){
        
        if let list = list {
            let tickedOffItems: Float = Float(list.tickedOffItems)
            let totalItems: Float = Float(list.totalItems)
            
            nameLabel.text = list.name
            
            if tickedOffItems > 0 && totalItems > 0 {
                progressBar.progress = tickedOffItems / totalItems
            } else {
                progressBar.progress = 0
            }
            
            tickedOffLabel.text = "\(list.tickedOffItems)/\(list.totalItems)"
            
            if totalItems > 0 && tickedOffItems == totalItems {
                progressBar.backgroundColor = UIColor(named: "LogoBlue")
                checkMarkImage.image = UIImage(systemName: "checkmark.circle")
                checkMarkImage.tintColor = UIColor(named: "LogoBlue")
            } else {
                progressBar.backgroundColor = UIColor(named: "LightGrey")
                checkMarkImage.image = UIImage(systemName: "circle")
                checkMarkImage.tintColor = .gray
            }
        }

    }
    
}

extension ListProgressCell {
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
