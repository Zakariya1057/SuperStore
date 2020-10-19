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
    var delegate: ListProgressDelegate
    var position: CGFloat?
    var lists:[ListModel]?
    var loading: Bool = false
    
    init(title: String,delegate: ListProgressDelegate, lists:[ListModel]) {
        self.title = title
        self.delegate = delegate
        self.lists = lists
    }
}

protocol ListProgressDelegate {
    func listSelected(identifier: String, list_id: Int)
}

class ListsProgressTableViewCell: UITableViewCell,CustomElementCell {

    var loading: Bool = true
    
    var model: ListsProgressElement!
    
    var lists:[ListModel] = []
    
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
    
    @IBOutlet var firstTextView: UIStackView!
    @IBOutlet var firstImageView: UIView!
    @IBOutlet var secondImageView: UIView!
    @IBOutlet var secondTextView: UIStackView!
    @IBOutlet var thirdImageView: UIView!
    @IBOutlet var thirdTextView: UIStackView!
    @IBOutlet var fourthImageView: UIView!
    @IBOutlet var fourhtTextView: UIStackView!
    
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
    
    var loadingViews:[UIView] {
        return [
            
            firstImageView,
            secondImageView,
            thirdImageView,
            fourthImageView,
            
            firstNameLabel,
            secondNameLabel,
            thirdNameLabel,
            fourthNameLabel,
            
            firstStatusLabel,
            secondStatusLabel,
            thirdStatusLabel,
            fourthStatusLabel,
            
        
        ]
    }
    
    var delegate: ListProgressDelegate?
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ListsProgressElement else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        self.lists = model.lists ?? []
        self.loading = model.loading
        
        configureUI()
    }
    
    func configureUI() {
        
        
        if(loading){
            startLoading()
            
            for (index, progress) in progressViews.enumerated() {
                progress.progress = 0
                nameLabels[index].text = "Shopping List"
            }
            
            return
        } else {
            stopLoading()
        }
        
        let listCount = lists.count
        
        for (index, list) in lists.enumerated() {

            listStackViews[index].isHidden = false
            
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
        
        if (listStackViews.count - listCount) != 0 {
            for index in 0...( (listStackViews.count - listCount) - 1){
                print("Remove: \((listStackViews.count) - index)")
                listStackViews[ ((listStackViews.count) - index) - 1].isHidden = true
            }
        }

        
        createListeners()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func createListeners(){
        
        for (index, list) in lists.enumerated() {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(listPressed(sender:)))
            gesture.name = "\(list.id)|\(list.identifier)"
            listStackViews[index].addGestureRecognizer(gesture)
        }
    }
    
    @objc func listPressed(sender: UIGestureRecognizer){
        if sender.name != nil {
            let details = sender.name!.split(separator: "|")
            let identifier: String = String(details[1])
            let list_id: Int = Int(details[0])!
            self.delegate?.listSelected(identifier: identifier, list_id: list_id)
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
