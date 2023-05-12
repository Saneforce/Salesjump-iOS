//
//  Brand Availability.swift
//  SAN SALES
//
//  Created by San eforce on 12/05/23.
//

import UIKit

class Brand_Availability: IViewController, UITableViewDelegate, UITableViewDataSource {
  
    let product:[String] = ["Sakthi Garam Masala 250 gm","SAN fair and Light for Women","SAN olive Oil 300ml","SAN Petrolium jelly 12gm","SAN Scrubber","SAN Skincare Gel 100gm","VIJI FOOD","777Green Pepper Pickle-300 Grams","Jasmine Cream 15gm","SAN Cool Powder 180gm","SAN Fair and Light for Men 30gm","Sakthi Garam Masala 250 gm","SAN fair and Light for Women","SAN olive Oil 300ml","SAN Petrolium jelly 12gm","SAN Scrubber","SAN Skincare Gel 100gm","VIJI FOOD","777Green Pepper Pickle-300 Grams","Jasmine Cream 15gm","SAN Cool Powder 180gm","SAN Fair and Light for Men 30gm","Sakthi Garam Masala 250 gm","SAN fair and Light for Women","SAN olive Oil 300ml","SAN Petrolium jelly 12gm","SAN Scrubber","SAN Skincare Gel 100gm","VIJI FOOD","777Green Pepper Pickle-300 Grams","Jasmine Cream 15gm","SAN Cool Powder 180gm","SAN Fair and Light for Men 30gm","Sakthi Garam Masala 250 gm","SAN fair and Light for Women","SAN olive Oil 300ml","SAN Petrolium jelly 12gm","SAN Scrubber","SAN Skincare Gel 100gm","VIJI FOOD","777Green Pepper Pickle-300 Grams","Jasmine Cream 15gm","SAN Cool Powder 180gm","SAN Fair and Light for Men 30gm"]
    @IBOutlet weak var BrandAV: UITableView!
    @IBOutlet weak var BTback: UIImageView!
    @IBOutlet weak var Titview: UIView!
    
    struct mnuItem: Any {
        let MasId: Int
        let MasName: String
        let TC : String
        let AC : String
        let ACPper: String
        let EC : String
    }
    var BrandAvailability:[mnuItem]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        BrandAV.delegate=self
        BrandAV.dataSource=self
        BTback.addTarget(target: self, action: #selector(GotoHome))
        
        Titview.layer.cornerRadius=10.0
        
     
        BrandAvailability.append(mnuItem(MasId: 1, MasName: "Sakthi Garam Masala 250 gm", TC: "", AC: "", ACPper: "", EC: ""))
        BrandAvailability.append(mnuItem(MasId: 2, MasName: "Sakthi Garam Masala 250 gm", TC: "", AC: "", ACPper: "", EC: ""))
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if BrandAV == tableView {
            
            return product.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:cellListItem
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = product[indexPath.row]
        
        return cell
     
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }

}
