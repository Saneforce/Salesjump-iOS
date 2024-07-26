//
//  MyResourceRoutes.swift
//  SAN SALES
//
//  Created by Naga Prasath on 26/07/24.
//

import UIKit


class MyResourceRoutes : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var tableViewList: UITableView!
    
    
    var lists : [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = "\(indexPath.row+1). " + "\(lists[indexPath.row]["name"] as? String ?? "")"
        cell.vwContainer.layer.borderColor = UIColor.black.cgColor
        cell.vwContainer.layer.borderWidth = 1
        cell.vwContainer.layer.masksToBounds = true
        return cell
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
