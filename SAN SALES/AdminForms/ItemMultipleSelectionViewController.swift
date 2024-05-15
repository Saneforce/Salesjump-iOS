//
//  ItemMultipleSelectionViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 26/04/24.
//

import UIKit

class ItemMultipleSelectionViewController <Item, Cell : UITableViewCell> : UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    
    var items : [Item] = []
    var originalItems : [Item] = []
    let reuseIdentifier = "Cell"
    let configure : (Cell , Item) -> ()
    var didSelect : (Item) -> () = { _ in}
    var save : ([Item]) -> () = { _ in}
    let tableView = UITableView()
    let lbl = UILabel()

    
    init(items: [Item], configure: @escaping (Cell, Item) -> Void) {
        self.items = items
        self.originalItems = items
        self.configure = configure
        super.init(nibName: "ItemMultipleSelectionViewController", bundle: Bundle(for: ItemMultipleSelectionViewController.self))
        
        self.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateDisplay()
    }

    
    func updateDisplay() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
    
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Bold", size: 20)
        lbl.textColor  = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
        lbl.backgroundColor = .white
        lbl.frame = CGRect(x: 10, y: 5, width: view.frame.size.width - 50, height: 40)
        

        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "CloseRed"), for: .normal)
        
        
        let txtSearch = UITextField()
        txtSearch.translatesAutoresizingMaskIntoConstraints  = false
        txtSearch.placeholder = "Search"
        txtSearch.font = UIFont(name: "Poppins-Regular", size: 15)
        txtSearch.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1.0))
        txtSearch.addTarget(self, action: #selector(filterList), for: .editingChanged)
        txtSearch.borderStyle = .roundedRect
        
        headerView.addSubview(lbl)
        headerView.addSubview(btn)
        headerView.addSubview(txtSearch)
        
        view.addSubview(headerView)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        let btnSave = UIButton()
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        btnSave.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        btnSave.setTitle("OK", for: .normal)
        btnSave.backgroundColor = UIColor(cgColor: CGColor(red: 16/255, green: 173/255, blue: 194/255, alpha: 1.0))
        footerView.addSubview(btnSave)
        
        view.addSubview(footerView)
        
        
        let constraintArray = [headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                               headerView.heightAnchor.constraint(equalToConstant: 90),
                               headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 5),
                               headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                               headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)]
        NSLayoutConstraint.activate(constraintArray)
        
        let constraintArray1 = [tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
                                tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
                                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5),
                                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(constraintArray1)
        
        let constraintArray2 = [footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
                                footerView.heightAnchor.constraint(equalToConstant: 70),
                                footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
                                footerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                                footerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)]
        NSLayoutConstraint.activate(constraintArray2)
        
        lbl.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5).isActive = true
        lbl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        lbl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        txtSearch.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant: 5).isActive = true
        txtSearch.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        txtSearch.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        txtSearch.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        btn.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15).isActive = true
        btn.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        btnSave.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        btnSave.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        btnSave.leftAnchor.constraint(equalTo: footerView.leftAnchor).isActive = true
        btnSave.rightAnchor.constraint(equalTo: footerView.rightAnchor).isActive = true
    }

    
    @objc func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAction() {
        save(self.items)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func filterList (sender : UITextField) {
        let txtbx: UITextField = sender
        if txtbx.text!.isEmpty {
            self.items = self.originalItems
        }else{
            self.items = self.originalItems.filter({(product) in
                let item = product as! [String : Any]
                let name: String = item["name"] as? String ?? ""
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lbl.text = title
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        let item  = items[indexPath.row]
        configure(cell, item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item  = items[indexPath.row]
        print(item)
        didSelect(item)
        tableView.reloadData()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


final class MultipleSelectionTableViewCell : UITableViewCell {
    
    var lblName = UILabel()
    var button = UIButton()
    var isWorked : Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        button.frame = CGRect(x: 20, y: 15, width: 25, height: 25)
        button.setImage(UIImage(named: "Select"), for: .selected)
    
        lblName.frame = CGRect(x: 55, y: 5, width: 300, height: 50)
        lblName.numberOfLines = 0
        lblName.font = UIFont(name: "Poppins-Regular", size: 14)!
        
        self.contentView.addSubview(button)
        self.contentView.addSubview(lblName)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
