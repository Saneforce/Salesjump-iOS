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
    @IBOutlet weak var Test: UILabel!
    
    @IBOutlet weak var Del_Img: UIView!
    deinit{
        imgProduct = nil
    }
}
