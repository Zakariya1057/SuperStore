//
//  ListPriceUpdateTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class PromotionGroupElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .offers
    var items: [HomeElementItemModel]
    var promotionPressed: (Int) -> Void
    var loading: Bool = true
    
    init(title: String, promotions: [PromotionsElementModel], promotionPressed: @escaping (Int) -> Void) {
        self.title = title
        self.items = promotions
        self.promotionPressed = promotionPressed
        
        configurePressed()
    }
    
    func setLoading(loading: Bool){
        self.loading = loading
        
        for item in items {
            item.loading = loading
        }
    }
    
    func configurePressed(){
        let promotions = items as! [PromotionsElementModel]
        for promotion in promotions {
            promotion.promotionPressed = self.promotionPressed
        }
    }
}

class PromotionsElementModel: HomeElementItemModel {
    var promotions: [PromotionModel] = []
    var scrollPosition: Float = 0
    var promotionPressed: ((Int) -> Void)? = nil
    var loading: Bool = true
    
    init(promotions: [PromotionModel]) {
        self.promotions = promotions
    }
}

class OffersCell: UITableViewCell, HomeElementCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var model: PromotionsElementModel!
    
    var promotionPressed: ((Int) -> Void)? = nil
    
    @IBOutlet var offersCollectionView: UICollectionView!
    
    var promotions: [PromotionModel] = []
    
    var loading: Bool = false
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? PromotionsElementModel else {
            print("Unable to cast model as ListsProgressElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.promotionPressed = model.promotionPressed
        self.promotions = model.promotions
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
        
        cell.promotion = loading ? nil : promotions[indexPath.row]

        cell.loading = loading
        cell.configureUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            // Offer Selected, Navigate
            if let promotionPressed = promotionPressed {
                promotionPressed(promotions[indexPath.row].id)
            }
        }
    }
}
