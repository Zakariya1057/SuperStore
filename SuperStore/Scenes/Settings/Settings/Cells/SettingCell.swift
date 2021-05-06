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
        "Store": UIImage(systemName: "cart"),
        "Notifications": UIImage(systemName: "bell"),
        
        "Clear Cache": UIImage(systemName: "trash"),
        
        "Feedback": UIImage(systemName: "bubble.left.and.bubble.right"),
        "Report Issues": UIImage(systemName: "pencil.circle"),
        
        "Login": UIImage(systemName: "person.crop.circle"),
        "Logout": UIImage(named: "Logout")
    ]
    
    @IBOutlet var iconImageView: UIImageView!
    
    var field: Settings.DisplayUserField!
    
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
        
        displayIcon()
        displayViews()
    }
    
    private func displayIcon(){
        if let iconImage = icons[field.name]{
            iconImageView.image = iconImage
        }
    }
    
    private func displayViews(){
        if field.type == .logout {
            disclosureView.isHidden = true
            valueLabel.isHidden = true
            notificationSwitch.isHidden = true
        } else if field.type == .notification {
            disclosureView.isHidden = true
            valueLabel.isHidden = true
            notificationSwitch.isHidden = false
        } else {
            disclosureView.isHidden = false
            valueLabel.isHidden = false
            notificationSwitch.isHidden = true
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
