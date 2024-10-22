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
    
    @IBOutlet weak var Collection_View_Two: UICollectionView!
    
    
    let data = [
            ["TC:", "PC:", "O. Value", "Pri Ord", "Pri. Value"],
            ["1", "1", "   50.09  ", "0", "0"]
        ]
    
    let test1 =  ["TC:", "PC:", "O. Value", "Pri Ord", "Pri. Value", "PC:", "O. Value", "Pri Ord", "Pri. Value"]
    let test2 =  ["1", "1", "   50.09  ", "0", "0", "1", "50.09", "0", "0"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Collection_View.dataSource = self
        Collection_View.delegate = self
        Collection_View_Two.dataSource = self
        Collection_View_Two.delegate = self
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if Collection_View_Two == collectionView{
            return 1
        }
        
            return data.count
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Collection_View_Two == collectionView{
            return test1.count
        }
            return data[section].count
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if Collection_View == collectionView{
            cell.lblText.text = data[indexPath.section][indexPath.item]
        }else if Collection_View_Two == collectionView{
            cell.lblText.text = test1[indexPath.row]
            cell.Test.text = test2[indexPath.row]
        }
        return cell
    }
}
