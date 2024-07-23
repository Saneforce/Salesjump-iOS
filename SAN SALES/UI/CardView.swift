//
//  CardView.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 22/05/22.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView {
    var cornnerRadius : CGFloat = 5
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 0.1
    
    var shadowColour : UIColor = ColorTheme.shadow_color
    var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}

class CardViewdata {
    func styleSummaryView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
    }
}
