//
//  ItemViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 27/03/24.
//

import UIKit

class ItemViewController <Item, Cell : UITableViewCell> : IViewController ,UITableViewDelegate,UITableViewDataSource {

    var items : [Item] = []
    var originalItems : [Item] = []
    let reuseIdentifier = "Cell"
    let configure : (Cell , Item) -> ()
    var didSelect : (Item) -> () = { _ in}
    let tableView = UITableView()
    let lbl = UILabel()
    
    init(items: [Item], configure: @escaping (Cell, Item) -> Void) {
        self.items = items
        self.originalItems = items
        self.configure = configure
        super.init(nibName: "ItemViewController", bundle: Bundle(for: ItemViewController.self))
        
        self.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.updateDisplay()
    }
    
    func updateDisplay() {
        
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
    //    headerView.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 90)
    //    headerView.backgroundColor = .green
        
        let headerStackView = UIStackView()
                
 //       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
   //     lbl.text = title
        lbl.font = UIFont(name: "Poppins-Bold", size: 20)
        lbl.textColor  = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
        lbl.backgroundColor = .white
        lbl.frame = CGRect(x: 10, y: 5, width: view.frame.size.width - 50, height: 40)
        

        
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
     //   btn.frame = CGRect(x: view.frame.size.width - 30, y: 10, width: 20, height: 20)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "CloseRed"), for: .normal)
        
        
        let txtSearch = UITextField()
        txtSearch.translatesAutoresizingMaskIntoConstraints  = false
  //      txtSearch.frame =  CGRect(x: 10, y: 50, width: view.frame.size.width - 80, height: 34)
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
        tableView.frame = CGRect(x: 0, y: 130, width: view.frame.size.width-50, height: view.frame.size.height + 100)
        tableView.backgroundColor = .white
        tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        
        
        let constraintArray = [headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                               headerView.heightAnchor.constraint(equalToConstant: 90),
                               headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 5),
                               headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                               headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)]
        NSLayoutConstraint.activate(constraintArray)
        
        let constraintArray1 = [tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
                                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5),
                                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -5),
                                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(constraintArray1)
        
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
    }
    
    @objc func closeAction() {
      //  self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func filterList (sender : UITextField) {
        let txtbx: UITextField = sender
        if txtbx.text!.isEmpty {
            self.items = self.originalItems
        }else{
            self.items = self.originalItems.filter({(product) in
                let item = product as! [String : Any]
                var name: String = item["name"] as? String ?? ""
                if name.isEmpty {
                    name = item["MOT"] as? String ?? ""
                }
                return name.lowercased().contains(txtbx.text!.lowercased())
            })
        }
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 90)
//        headerView.backgroundColor = .white
//
//        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = title
//        lbl.font = UIFont(name: "Poppins-Bold", size: 20)
//        lbl.textColor  = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
//        lbl.backgroundColor = .white
//        lbl.frame = CGRect(x: 10, y: 5, width: view.frame.size.width - 50, height: 40)
//
//
//        let btn = UIButton()
//        btn.frame = CGRect(x: view.frame.size.width - 30, y: 10, width: 20, height: 20)
//        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
//        btn.setImage(UIImage(named: "CloseRed"), for: .normal)
//
//
//        let txtSearch = UITextField()
//        txtSearch.frame =  CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 34)
//        txtSearch.placeholder = "Search"
//        txtSearch.font = UIFont(name: "Poppins-Regular", size: 15)
//        txtSearch.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1.0))
//        txtSearch.addTarget(self, action: #selector(filterList), for: .editingChanged)
//        txtSearch.borderStyle = .roundedRect
//
//        headerView.addSubview(lbl)
//        headerView.addSubview(btn)
//        headerView.addSubview(txtSearch)
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 90
//    }
    
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
        didSelect(item)
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


final class ItemViewController1 <Item, Cell : UITableViewCell> : UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    
    var items : [Item] = []
    var originalItems : [Item] = []
    let reuseIdentifier = "Cell"
    let configure : (Cell , Item) -> ()
    var didSelect : (Item) -> () = { _ in}
    let tableView = UITableView()
    
    init(items: [Item], configure: @escaping (Cell, Item) -> Void) {
        self.items = items
        self.originalItems = items
        self.configure = configure
        super.init(nibName: "ItemViewController", bundle: Bundle(identifier: "Main"))
        
     //   super.init(nibName: <#T##String?#>, bundle: <#T##Bundle?#>)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ItemViewController dealloc")
    }
    
    override func viewDidLoad() {
   //     self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.backgroundColor = .white
        
        
        self.updateDisplay()
    }
    
    func updateDisplay() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 90)
        headerView.backgroundColor = .white
                
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = title
        lbl.font = UIFont(name: "Poppins-Bold", size: 20)
        lbl.textColor  = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
        lbl.backgroundColor = .white
        lbl.frame = CGRect(x: 10, y: 5, width: view.frame.size.width - 50, height: 40)
        
        
        let btn = UIButton()
        btn.frame = CGRect(x: view.frame.size.width - 30, y: 10, width: 20, height: 20)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "CloseRed"), for: .normal)
        
        
        let txtSearch = UITextField()
        txtSearch.frame =  CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 34)
        txtSearch.placeholder = "Search"
        txtSearch.font = UIFont(name: "Poppins-Regular", size: 15)
        txtSearch.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1.0))
        txtSearch.addTarget(self, action: #selector(filterList), for: .editingChanged)
        txtSearch.borderStyle = .roundedRect
        
        headerView.addSubview(lbl)
        headerView.addSubview(btn)
        headerView.addSubview(txtSearch)
        
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 100, height: 90)
        tableView.backgroundColor = .white
        tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(headerView)
        view.addSubview(tableView)
    }
    
    @objc func closeAction() {
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
        didSelect(item)
    }
}

final class SingleSelectionTableViewCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ItemTableViewController<Item, Cell : UITableViewCell> : UITableViewController {
    var items : [Item] = []
    var originalItems : [Item] = []
    let reuseIdentifier = "Cell"
    let configure : (Cell , Item) -> ()
    var didSelect : (Item) -> () = { _ in}
    
    init(items : [Item] ,configure: @escaping (Cell, Item) -> Void) {
        self.configure = configure
        super.init(style: .grouped)
        self.items = items
        self.originalItems = items
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ItemTableViewController dealloc")
    }
    
    override func viewDidLoad() {
   //     self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.backgroundColor = .white
        tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.estimatedSectionHeaderHeight = 90
        tableView.contentInset.top = -25
        
        tableView.backgroundColor = .white
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 90)
        headerView.backgroundColor = .white
                
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = title
        lbl.font = UIFont(name: "Poppins-Bold", size: 20)
        lbl.textColor  = UIColor(cgColor: CGColor(red: 54/255, green: 53/255, blue: 53/255, alpha: 1.0))
        lbl.backgroundColor = .white
        lbl.frame = CGRect(x: 10, y: 5, width: tableView.frame.size.width - 50, height: 40)
        
        
        let btn = UIButton()
        btn.frame = CGRect(x: tableView.frame.size.width - 30, y: 10, width: 20, height: 20)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "CloseRed"), for: .normal)
        
        
        let txtSearch = UITextField()
        txtSearch.frame =  CGRect(x: 10, y: 50, width: tableView.frame.size.width - 20, height: 34)
        txtSearch.placeholder = "Search"
        txtSearch.font = UIFont(name: "Poppins-Regular", size: 15)
        txtSearch.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1.0))
        txtSearch.addTarget(self, action: #selector(filterList), for: .editingChanged)
        txtSearch.borderStyle = .roundedRect
        
        headerView.addSubview(lbl)
        headerView.addSubview(btn)
        headerView.addSubview(txtSearch)
        
        return headerView
    }
    
    @objc func closeAction() {
       // self.dismiss(animated: true)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        let item  = items[indexPath.row]
        configure(cell, item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item  = items[indexPath.row]
        didSelect(item)
    }
    
}



