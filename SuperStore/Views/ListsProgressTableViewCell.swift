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
    var delegate: ListSelectedDelegate
    var position: CGFloat?
    var lists:[ListProgressModel]?
    
    init(title: String,delegate: ListSelectedDelegate, lists:[ListProgressModel]) {
        self.title = title
        self.delegate = delegate
        self.lists = lists
    }
}

//protocol ListSelectedDelegate {
//    func listPressed(list_id: Int)
//}

class ListsProgressTableViewCell: UITableViewCell,CustomElementCell {

    var model: ListsProgressElement!
    
    var lists:[ListProgressModel] = []
    
    @IBOutlet weak var listViewButton: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var forthStackView: UIStackView!
    @IBOutlet var thirdStackView: UIStackView!
    @IBOutlet var secondStackView: UIStackView!
    @IBOutlet var firstListStackView: UIStackView!
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var secondNameLabel: UILabel!
    @IBOutlet var thirdNameLabel: UILabel!
    @IBOutlet var fourthNameLabel: UILabel!
    
    @IBOutlet var firstStatusLabel: UILabel!
    @IBOutlet var secondStatusLabel: UILabel!
    @IBOutlet var thirdStatusLabel: UILabel!
    @IBOutlet var fourthStatusLabel: UILabel!
    
    @IBOutlet var firstProgressView: UIProgressView!
    @IBOutlet var secondProgressView: UIProgressView!
    @IBOutlet var thirdProgressView: UIProgressView!
    @IBOutlet var fourthProgressView: UIProgressView!
    
    @IBOutlet var firstIconImageView: UIImageView!
    @IBOutlet var secondIconImageView: UIImageView!
    @IBOutlet var thirdIconImageView: UIImageView!
    @IBOutlet var fourthIconImageView: UIImageView!
    
    var listStackViews:[UIStackView] {
        return [
            firstListStackView,
            secondStackView,
            thirdStackView,
            forthStackView
        ]
    }
    
    var nameLabels:[UILabel] {
        return [
            firstNameLabel,
            secondNameLabel,
            thirdNameLabel,
            fourthNameLabel,
        ]
    }
    
    var statusLabels: [UILabel] {
        return [
            firstStatusLabel,
            secondStatusLabel,
            thirdStatusLabel,
            fourthStatusLabel
        ]
    }
    
    var progressViews:[UIProgressView] {
        return [
            firstProgressView,
            secondProgressView,
            thirdProgressView,
            fourthProgressView
        ]
    }
    
    var iconViews: [UIImageView] {
        return [
            firstIconImageView,
            secondIconImageView,
            thirdIconImageView,
            fourthIconImageView
        ]
    }
    
    var delegate: ListSelectedDelegate?
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ListsProgressElement else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        self.lists = model.lists ?? []
        
        configureUI()
    }
    
    func configureUI() {
        
        for (index, list) in lists.enumerated() {
            
            let progress:Float = Float(list.tickedOffItems)/Float(list.totalItems)
            let percentage = progress * 100
            
            nameLabels[index].text = list.name
            statusLabels[index].text = "\(list.tickedOffItems)/\(list.totalItems)"
            progressViews[index].progress = progress
            
            var color = UIColor(named: "LogoBlue")
            var image = UIImage(systemName: "circle")
            
            if percentage == 100 {
                color = UIColor(named: "LogoBlue")
                image = UIImage(systemName: "checkmark.circle")
            } else if percentage > 50 {
                color = UIColor(named: "Green.Light")
            } else if percentage > 20 {
                color = .systemYellow
            } else {
                color = UIColor(red: 0.44, green: 0.44, blue: 0.47, alpha: 1.00)
            }
            
            iconViews[index].tintColor = color
            progressViews[index].tintColor = color
            iconViews[index].image = image
            
        }
        
        createListeners()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func createListeners(){
        
//        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(listPressed(sender:)))
//        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(listPressed(sender:)))
//        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(listPressed(sender:)))
//        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(listPressed(sender:)))
//
//        gesture1.name = "1"
//        gesture2.name = "2"
//        gesture3.name = "3"
//        gesture4.name = "4"
//
//        firstListStackView.addGestureRecognizer(gesture1)
//        secondStackView.addGestureRecognizer(gesture2)
//        thirdStackView.addGestureRecognizer(gesture3)
//        forthStackView.addGestureRecognizer(gesture4)
        
        for (index, list) in lists.enumerated() {
            var gesture = UITapGestureRecognizer(target: self, action: #selector(listPressed(sender:)))
            gesture.name = String(list.id)
            listStackViews[index].addGestureRecognizer(gesture)
        }
    }
    
    @objc func listPressed(sender: UIGestureRecognizer){
        if sender.name != nil {
            self.delegate?.listSelected(list_id: Int(sender.name!)!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
