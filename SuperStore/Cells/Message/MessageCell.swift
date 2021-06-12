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
    
    var retryButtonPressed: ((_ message: MessageModel) -> Void)? = nil

    @IBOutlet private var messageTextLabel: UILabel!
    
    @IBOutlet private var sentView: UIView!
    @IBOutlet private var receivedView: UIView!
    
    @IBOutlet private var sendImageView: UIImageView!
    @IBOutlet private var receivedImageView: UIImageView!
    
    @IBOutlet private var sendTextLabel: UILabel!
    @IBOutlet private var receivedTextLabel: UILabel!
    
    @IBOutlet private var parentStackView: UIStackView!
    
    @IBOutlet private var receviedWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var sentWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet private var errorViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(){
        let label: UILabel
        
        var width: CGFloat = textWidth(text: message.text) + 30
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 100
        var multiLine: Bool = false
        
        if width >= maxWidth {
            width = maxWidth
            multiLine = true
        }
        
        let showError: Bool = message.status == .error
        errorViews.forEach { view in view.isHidden = !showError }
        
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
        sentView.isHidden = false
        receivedView.isHidden = true

        
        changeImage(imageView: sendImageView!, "chat_bubble_sent")
        sendImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
        messageTextLabel.textColor = .white
    }
    
    func displayReceived() {
        receivedView.isHidden = false
        sentView.isHidden = true
        
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
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        if let retryButtonPressed = retryButtonPressed {
            retryButtonPressed(message)
        }
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
