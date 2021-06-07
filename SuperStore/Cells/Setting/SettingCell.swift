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
    }
    
    private func setWidth(){
        if setting.type != .password && setting.value == nil {
            stackViewWidth.constant = 200
            detailStackView.layoutIfNeeded()
        }
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
