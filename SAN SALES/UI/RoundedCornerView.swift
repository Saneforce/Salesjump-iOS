//
//  RoundedCornerView.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 08/04/22.
//

import Foundation
import UIKit
class RoundedCornerView:UIView{
    override func awakeFromNib() {
        self.clipsToBounds=true
        self.layer.cornerRadius = 5.0
    }
}
