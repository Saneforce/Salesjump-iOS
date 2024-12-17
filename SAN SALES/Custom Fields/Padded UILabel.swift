//
//  Padded UILabel.swift
//  SAN SALES
//
//  Created by Anbu j on 17/12/24.
//

import UIKit

class PaddedLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: edgeInsets)
        super.drawText(in: insetRect)
    }
}
