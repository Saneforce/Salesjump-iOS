//
//  LabelSelect.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 08/03/22.
//

import Foundation
import UIKit

class LabelSelect:UILabel{
    var insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    override func awakeFromNib() {
        self.clipsToBounds=true
        self.layer.cornerRadius = 6.0
    }
    override func drawText(in rect: CGRect) {
        let rightImg: UIImageView = UIImageView(frame: CGRect(x: self.frame.width - 25, y: (self.frame.height/2)-3, width: 10, height: 6))
        rightImg.image = UIImage(systemName: "chevron.down")
        self.addSubview(rightImg)
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

class LabelSelectWithout:UILabel{
    var insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    override func awakeFromNib() {
        self.clipsToBounds=true
        self.layer.cornerRadius = 6.0
    }
    override func drawText(in rect: CGRect) {
        let rightImg: UIImageView = UIImageView(frame: CGRect(x: self.frame.width - 25, y: (self.frame.height/2)-3, width: 10, height: 6))
        rightImg.image = UIImage(systemName: "")
        self.addSubview(rightImg)
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
