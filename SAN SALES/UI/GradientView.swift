//
//  GradientView.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 21/07/22.
//

import Foundation
import UIKit

class GradientView: UIView {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradientLayer()
    }

    func configureGradientLayer(){
        backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1).cgColor, UIColor(red: 51/255, green: 116/255, blue: 130/255, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.frame = bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
