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
        "User Settings": UIImage(systemName: "person.circle"),
        "Device Storage": UIImage(systemName: "archivebox"),
        "Regions & Stores": UIImage(systemName: "location.circle"),
        
        "Name": UIImage(systemName: "person"),
        "Email": UIImage(systemName: "envelope"),
        "Password": UIImage(systemName: "lock"),
        "Notifications": UIImage(systemName: "bell"),
        
        "Store": UIImage(systemName: "cart"),
        "Province": UIImage(systemName: "location.circle"),
        
        "Clear Cache": UIImage(systemName: "trash"),
        
        "Help & Feedback": UIImage(systemName: "questionmark.circle"),
        "Help": UIImage(systemName: "questionmark.circle"),
        "Suggest A Feature": UIImage(systemName: "lightbulb"),
        "Feedback": UIImage(systemName: "bubble.left"),
        "Report An Issue": UIImage(systemName: "exclamationmark.circle"),
        
        "Delete Accoubt": UIImage(systemName: "person.crop.circle.badge.xmark"),
        
        "Login": UIImage(systemName: "person.crop.circle"),
        "Logout": UIImage(named: "Logout")
    ]
    
    @IBOutlet var iconImageView: UIImageView!
    
    var setting: SettingModel!
    
    @IBOutlet var detailStackView: UIStackView!
    @IBOutlet var stackViewWidth: NSLayoutConstraint!
    
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var notificationSwitch: UISwitch!
    
    @IBOutlet var disclosureView: UIView!
    
    @IBOutlet var badgeParentView: UIView!
    @IBOutlet var badgeView: UIView!
    @IBOutlet var badgeText: UILabel!
    
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
        keyLabel.text = setting.name
        valueLabel.text = setting.value
        
        setNotification(enabled: setting.on)
        
        setWidth()
        
        displayIcon()
        displayViews()
        
        displayBadge()
    }
    
    private func setWidth(){
        let width: CGFloat = (setting.type != .password && setting.value == nil) ? 200 : 150
        stackViewWidth.constant = width
        detailStackView.layoutIfNeeded()
    }
    
    private func displayIcon(){
        if let iconImage = icons[setting.name]{
            iconImageView.image = iconImage
        }
    }
    
    private func displayViews(){
        
        notificationSwitch.isHidden = setting.type != .notification
        
        if setting.type == .logout ||
            setting.type == .notification ||
            setting.type == .delete ||
            setting.type == .login {
            
            disclosureView.isHidden = true
            valueLabel.isHidden = true
        } else {
            disclosureView.isHidden = false
            valueLabel.isHidden = false
        }
    }
    
    private func displayBadge(){
        badgeParentView.isHidden = ( setting.badgeNumber == nil || setting.badgeNumber == 0)
        
        if let number = setting.badgeNumber, number > 0 {
            setBadgeViewBorder()
            badgeText.text = String(number)
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

extension SettingCell {
    func setBadgeViewBorder(){
        badgeView.layer.cornerRadius = 10
    }
}
