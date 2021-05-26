//
//  SettingCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    var icons: [String: UIImage?] = [
        "Name": UIImage(systemName: "person"),
        "Email": UIImage(systemName: "envelope"),
        "Password": UIImage(systemName: "lock"),
        "Notifications": UIImage(systemName: "bell"),
        
        "Store": UIImage(systemName: "cart"),
        "Province": UIImage(systemName: "location.circle"),
        
        "Clear Cache": UIImage(systemName: "trash"),
        
        "Feedback": UIImage(systemName: "bubble.left.and.bubble.right"),
        "Report Issues": UIImage(systemName: "pencil.circle"),
        "Delete Accoubt": UIImage(systemName: "person.crop.circle.badge.xmark"),
        
        "Login": UIImage(systemName: "person.crop.circle"),
        "Logout": UIImage(named: "Logout")
    ]
    
    @IBOutlet var iconImageView: UIImageView!
    
    var field: Settings.DisplayUserField!
    
    @IBOutlet var detailStackView: UIStackView!
    @IBOutlet var stackViewWidth: NSLayoutConstraint!
    
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var notificationSwitch: UISwitch!
    
    @IBOutlet var disclosureView: UIView!
    
    var notificationSwitchPressedCallback: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI(){
        keyLabel.text = field.name
        valueLabel.text = field.value
        
        setNotification(enabled: field.on)
        
        setWidth()
        
        displayIcon()
        displayViews()
    }
    
    private func setWidth(){
        if field.type == .delete {
            stackViewWidth.constant = 200
            detailStackView.layoutIfNeeded()
        }
    }
    
    private func displayIcon(){
        if let iconImage = icons[field.name]{
            iconImageView.image = iconImage
        }
    }
    
    private func displayViews(){
        
        notificationSwitch.isHidden = field.type != .notification
        
        if field.type == .logout ||
            field.type == .notification ||
            field.type == .delete ||
            field.type == .login {
            
            disclosureView.isHidden = true
            valueLabel.isHidden = true
        } else {
            disclosureView.isHidden = false
            valueLabel.isHidden = false
        }
    }
    
}

extension SettingCell {
    @IBAction func switchPressed(_ sender: UISwitch) {
        if let notificationSwitchPressedCallback = notificationSwitchPressedCallback {
            notificationSwitchPressedCallback(sender.isOn)
        }
    }
    
    func setNotification(enabled: Bool){
        notificationSwitch.setOn(enabled, animated: true)
    }
}
