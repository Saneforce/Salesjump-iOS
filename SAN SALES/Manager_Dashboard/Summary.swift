//
//  Summary.swift
//  SAN SALES
//
//  Created by San eforce on 01/12/23.
//

import UIKit
import Alamofire
import FSCalendar

class Summary: IViewController,FSCalendarDelegate,FSCalendarDataSource {

    @IBOutlet weak var Date_View: UIView!
    @IBOutlet weak var Date_lbl: UILabel!
    @IBOutlet weak var All_Filed: UIView!
    @IBOutlet weak var Cal_View: UIView!
    @IBOutlet weak var Calendar: FSCalendar!
    @IBOutlet weak var All_Field_View: UIView!
    @IBOutlet weak var Search: UIView!
    
    var SelectDate : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendar.delegate=self
        Calendar.dataSource=self
        //Date_Card_View
        Date_View.backgroundColor = .white
        Date_View.layer.cornerRadius = 10.0
        Date_View.layer.shadowColor = UIColor.gray.cgColor
        Date_View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Date_View.layer.shadowRadius = 3.0
        Date_View.layer.shadowOpacity = 0.7
        
        //All_Filed_Card_View
        All_Filed.backgroundColor = .white
        All_Filed.layer.cornerRadius = 10.0
        All_Filed.layer.shadowColor = UIColor.gray.cgColor
        All_Filed.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        All_Filed.layer.shadowRadius = 3.0
        All_Filed.layer.shadowOpacity = 0.7
        
        Search.backgroundColor = .white
        Search.layer.cornerRadius = 10.0
        Search.layer.shadowColor = UIColor.gray.cgColor
        Search.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Search.layer.shadowRadius = 3.0
        Search.layer.shadowOpacity = 0.5
        
        Date_View.addTarget(target: self, action: #selector(dateView))
        All_Filed.addTarget(target: self, action: #selector(FiledData))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        Date_lbl.text = formatter.string(from: Date())
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        let formatters = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatters.dateFormat = "yyyy-MM-dd"
        //print("did select date \(formatter.string(from: date))")
        print("did select date \(formatters.string(from: date))")
        let selectedDates = calendar.selectedDates.map({formatter.string(from: $0)})
        let selectedDates_Attendance = calendar.selectedDates.map({formatters.string(from: $0)})
        print("selected dates is \(selectedDates_Attendance)")
        if let firstDate = selectedDates_Attendance.first {
            print("Selected date outside the box: \(firstDate)")
            SelectDate = firstDate
        } else {
            print("No selected dates.")
        }
        Date_lbl.text = formatter.string(from: date)
       
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
     
        Cal_View.isHidden = true
    }
    @objc func dateView(){
        Cal_View.isHidden = false
    }
    @objc func FiledData(){
        All_Field_View.isHidden = false
    }
    @IBAction func Cancel_Bt(_ sender: Any) {
        Cal_View.isHidden = true
    }
    
    @IBAction func All_Filed_Close(_ sender: Any) {
        All_Field_View.isHidden = true
    }
    

}
