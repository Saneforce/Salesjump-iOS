//
//  EditTextField.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 16/05/22.
//

import Foundation
import UIKit

class EditTextField:UITextField {
    var insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    override func awakeFromNib() {
        self.clipsToBounds=true
        self.layer.cornerRadius = 6.0
        self.backgroundColor = UIColor(red: 239.0/255, green: 243.0/255, blue: 251.0/255, alpha: 1.0)
        
        let paddingLView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: self.frame.size.height))
        self.leftView = paddingLView
        self.leftViewMode = .always
    
        let paddingRView = UIView(frame: CGRect(x: 0, y: 0, width:  10.0, height: self.frame.size.height))
        self.rightView = paddingRView
        self.rightViewMode = .always
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
    
}
