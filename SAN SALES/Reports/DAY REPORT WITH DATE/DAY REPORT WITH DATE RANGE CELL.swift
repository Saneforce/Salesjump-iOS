//
//  DAY REPORT WITH DATE RANGE CELL.swift
//  SAN SALES
//
//  Created by Anbu j on 22/10/24.
//

import UIKit

class DAY_REPORT_WITH_DATE_RANGE_CELL: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
 
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var Collection_View: UICollectionView!
    
    let data = [
            ["TC:", "PC:", "O. Value", "Pri Ord", "Pri. Value"],
            ["1", "1", "50.09", "0", "0"]
        ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Collection_View.dataSource = self
        Collection_View.delegate = self
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return data.count
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data[section].count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if Collection_View == collectionView{
            cell.lblText.text = data[indexPath.section][indexPath.item]
        }
        return cell
    }
    
}
