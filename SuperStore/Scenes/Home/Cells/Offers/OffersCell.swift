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
    var offerPressedCallBack: (Int) -> Void
    var position: CGFloat?
    var promotions: [PromotionModel]?
    var loading: Bool = false
    
    init(title: String, offerPressedCallBack: @escaping (Int) -> Void, promotions: [PromotionModel]) {
        self.title = title
        self.offerPressedCallBack = offerPressedCallBack
        self.promotions = promotions
    }
}

class OffersCell: UITableViewCell,CustomElementCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var model: OffersElement!
    
    var offerPressedCallBack: ((Int) -> Void)? = nil
    
    @IBOutlet var offersCollectionView: UICollectionView!
    
    var promotions: [PromotionModel] = []
    
    var loading: Bool = true
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? OffersElement else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.offerPressedCallBack = model.offerPressedCallBack
        self.promotions = model.promotions ?? []
        self.loading = model.loading
        
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OffersCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loading ? 4 : promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = offersCollectionView.dequeueReusableCell(withReuseIdentifier: K.Collections.OfferCollectionCell.CellIdentifier, for: indexPath) as! OfferCollectionViewCell
        
        if !loading {
            cell.promotion = promotions[indexPath.row]
        }
        
        cell.loading = loading
        cell.configureUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            // Offer Selected, Navigate
            if let offerPressedCallBack = offerPressedCallBack {
                offerPressedCallBack(promotions[indexPath.row].id)
            }
        }
    }
}
