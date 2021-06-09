//
//  MessageCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var message: MessageModel!

    @IBOutlet var messageTextLabel: UILabel!
    
    @IBOutlet var sentView: UIView!
    @IBOutlet var receivedView: UIView!
    
    @IBOutlet var sendImageView: UIImageView!
    @IBOutlet var receivedImageView: UIImageView!
    
    @IBOutlet var sendTextLabel: UILabel!
    @IBOutlet var receivedTextLabel: UILabel!
    
    @IBOutlet var receviedWidthConstraint: NSLayoutConstraint!
    @IBOutlet var sentWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var parentStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(){
        let label: UILabel
        
        var width: CGFloat = textWidth(text: message.text) + 30
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 65
        var multiLine: Bool = false
        
        if width >= maxWidth {
            width = maxWidth
            multiLine = true
        }
        
        if message.direction == .sent {
            displaySent()
            label = sendTextLabel
            
            sendTextLabel.textAlignment = multiLine ? .left : .right
            
            sentWidthConstraint.constant = CGFloat(width)
            receivedImageView.layoutIfNeeded()
        } else {
            displayReceived()
            label = receivedTextLabel
            
            receviedWidthConstraint.constant = CGFloat(width)
            receivedImageView.layoutIfNeeded()
        }
    
        label.text = message.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
    func displaySent() {
        receivedView.isHidden = true
        sentView.isHidden = false
        
        changeImage(imageView: sendImageView!, "chat_bubble_sent")
        sendImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
        messageTextLabel.textColor = .white
    }
    
    func displayReceived() {
        sentView.isHidden = true
        receivedView.isHidden = false
        
        changeImage(imageView: receivedImageView!, "chat_bubble_received")
        receivedImageView.tintColor = UIColor(named: "chat_bubble_color_received")
        messageTextLabel.textColor = .black
    }
    
    func changeImage(imageView: UIImageView, _ name: String) {
        guard let image = UIImage(named: name) else { return }
        imageView.image = image
            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 30, bottom: 17, right: 30), resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
}

extension MessageCell {
    func textWidth(text: String) -> CGFloat {
        
        let cellFontSize:CGFloat = 16
        
        let cellFont: UIFont = UIFont.systemFont(ofSize: cellFontSize, weight: .regular)

        let cellParagraphStyle = NSMutableParagraphStyle()

        let cellTextAttributes = [NSAttributedString.Key.font: cellFont, NSAttributedString.Key.paragraphStyle: cellParagraphStyle]
        
        let string = NSAttributedString(string: message.text, attributes: cellTextAttributes)
        
        let cellDrawingOptions: NSStringDrawingOptions = [
        .usesLineFragmentOrigin, .usesFontLeading]
        cellParagraphStyle.lineHeightMultiple = 1.0
        cellParagraphStyle.lineBreakMode = .byWordWrapping

        return string.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: cellDrawingOptions, context: nil).width
    }
}
