//
//  CollectionCell.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 09/04/22.
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell{
    @IBOutlet weak var lblCap: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwBtnDel: UIView!
    
    deinit{
        imgProduct = nil
    }
}
