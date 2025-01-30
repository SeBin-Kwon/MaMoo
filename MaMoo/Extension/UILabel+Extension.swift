//
//  UILabel+Extension.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit

extension UILabel {
    func addImage(name: String) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: name)
        attachment.image = attachment.image?.withTintColor(.maMooGray)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else { return }
        let strLabelText = NSAttributedString(string: txt)
        let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
        mutableAttachmentString.append(strLabelText)
        self.attributedText = mutableAttachmentString
    }
    
//    func addImageWith(name: String, behindText: Bool) {
//
//            let attachment = NSTextAttachment()
//            attachment.image = UIImage(systemName: name)
//            attachment.image = attachment.image?.withTintColor(.white)
//            let attachmentString = NSAttributedString(attachment: attachment)
//
//            guard let txt = self.text else { return }
//
//            if behindText {
//                let strLabelText = NSMutableAttributedString(string: txt)
//                strLabelText.append(attachmentString)
//                self.attributedText = strLabelText
//            } else {
//                let strLabelText = NSAttributedString(string: txt)
//                let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
//                mutableAttachmentString.append(strLabelText)
//                self.attributedText = mutableAttachmentString
//            }
//        }
}
