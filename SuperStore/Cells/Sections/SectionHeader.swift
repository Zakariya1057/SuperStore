//
//  HomeSectionHeader.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var headingLabel: UILabel!

    var showViewAllButton: Bool = false
    
    @IBOutlet var viewAllView: UIView!
    @IBOutlet var viewAllButton: UIButton!

    var viewAllButtonPressed: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        viewAllButton.isHidden = !showViewAllButton
        moveImageToRightSide()
        setupViewAllGesture()
    }
    
    func moveImageToRightSide(){
        let direction: UIUserInterfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
        viewAllButton.semanticContentAttribute = (direction == .rightToLeft) ? .forceLeftToRight : .forceRightToLeft
    }
    
    @IBAction func viewAllButtonPressed(_ sender: UIButton) {
        viewAllViewPressed()
    }
    
    func setupViewAllGesture(){
        let viewAllViewGesture = UITapGestureRecognizer(target: self, action: #selector(viewAllViewPressed))
        viewAllView.addGestureRecognizer(viewAllViewGesture)
    }
    
    @objc func viewAllViewPressed(){
        if let viewAllButtonPressed = viewAllButtonPressed {
            viewAllButtonPressed()
        }
    }
}
