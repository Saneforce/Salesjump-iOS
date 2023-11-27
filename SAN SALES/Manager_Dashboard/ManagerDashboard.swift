//
//  ManagerDashboard.swift
//  SAN SALES
//
//  Created by San eforce on 16/11/23.
//

import UIKit

class ManagerDashboard: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var BackBT: UIImageView!
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    
    var lstBrands: [AnyObject] = []
       var Manager_Cap: [String] = ["Attendance","Summary","Performance","Location","Coverage"]

       override func viewDidLoad(){
           super.viewDidLoad()
           DateView.layer.cornerRadius = 10
           DateView.layer.shadowColor = UIColor.black.cgColor
           DateView.layer.shadowOpacity = 0.5
           DateView.layer.shadowOffset = CGSize(width: 0, height: 2)
           DateView.layer.shadowRadius = 4

           cvCategory.delegate = self
           cvCategory.dataSource = self
        

           BackBT.isUserInteractionEnabled = true
           BackBT.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GotoHome)))

           let localStorage = UserDefaults.standard
           if let lstCatData = localStorage.string(forKey: "Brand_Master"),
              let list = GlobalFunc.convertToDictionary(text: lstCatData) as? [AnyObject] {
               lstBrands = list
           }
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return Manager_Cap.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell: CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
           cell.lblText.layer.cornerRadius = 10
           cell.lblText.clipsToBounds = true
           cell.lblText.layer.borderWidth = 1.0
           cell.lblText.layer.borderColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00).cgColor
           cell.lblText?.text = Manager_Cap[indexPath.row]
           return cell
       }
       @objc private func GotoHome() {
           navigationController?.popViewController(animated: true)
       }

   }
