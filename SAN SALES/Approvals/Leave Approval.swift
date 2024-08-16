//
//  Leave Approval.swift
//  SAN SALES
//
//  Created by Anbu j on 16/08/24.
//

import UIKit

class Leave_Approval: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var BackBT: UIImageView!
    @IBOutlet weak var Leave_View_TB: UITableView!
    @IBOutlet weak var Approv_View: UIView!
    @IBOutlet weak var Apr_Close_BT: UIImageView!
    
    
    
    let cardViewInstance = CardViewdata()
    override func viewDidLoad() {
        super.viewDidLoad()
        Leave_View_TB.delegate = self
        Leave_View_TB.dataSource = self
        BackBT.addTarget(target: self, action: #selector(GotoHome))
        Apr_Close_BT.addTarget(target: self, action: #selector(Close_apr_view))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:cellListItem = tableView.dequeueReusableCell(withIdentifier: "Cell") as! cellListItem
        cell.lblText.text = "Test(Mani)"
        cell.lblText2.text = "1"
        cell.Leave_Apr.tag = indexPath.row
        cell.Leave_Apr.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        cardViewInstance.styleSummaryView(cell.Leave_Apr)
        return cell
    }
    
    @objc func buttonClicked(_ sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(sender.tag)
        Approv_View.isHidden = false
    }

    
    
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func Close_apr_view() {
        Approv_View.isHidden = true
    }
}
