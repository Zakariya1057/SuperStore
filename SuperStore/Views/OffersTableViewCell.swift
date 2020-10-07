//
//  ListPriceUpdateTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class OffersElement: CustomElementModel {
    var title: String
    var type: CustomElementType { return .offers }
    var delegate: OfferSelectedDelegate
    var position: CGFloat?
    
    init(title: String,delegate: OfferSelectedDelegate) {
        self.title = title
        self.delegate = delegate
    }
}

protocol OfferSelectedDelegate {
    func showPromotion(promotion_id: Int)
}

class OffersTableViewCell: UITableViewCell,CustomElementCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var model: OffersElement!
    
    var delegate: OfferSelectedDelegate?
    
    @IBOutlet var offersCollectionView: UICollectionView!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? OffersElement else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        
        configureUI()
        offersCollectionView.reloadData()
    }
    
    func configureUI() {

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        offersCollectionView.register(UINib(nibName: K.Collections.OfferCollectionCell.CellNibName, bundle: nil), forCellWithReuseIdentifier: K.Collections.OfferCollectionCell.CellIdentifier)
        
        offersCollectionView.delegate = self
        offersCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OffersTableViewCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = offersCollectionView.dequeueReusableCell(withReuseIdentifier: K.Collections.OfferCollectionCell.CellIdentifier, for: indexPath) as! OfferCollectionViewCell
//        cell.product = products[indexPath.row]
//        cell.configureUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Product Selected, Navigate
        print("Offer Selected")
        self.delegate?.showPromotion(promotion_id: 1)
    }
}
