//
//  CalendarViewController.swift
//  SAN SALES
//
//  Created by Naga Prasath on 13/05/24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController , FSCalendarDelegate ,FSCalendarDataSource{
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    
    var didSelect : (String) -> () = { _ in}
    
    var date : Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendarView.delegate = self
        calendarView.dataSource = self
        
//        self.calendarView.setCurrentPage(date ?? Date(), animated: true)
//        self.calendarView.reloadData()
    }

    
    @IBAction func closeAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
    }
    
    init() {
        super.init(nibName: "CalendarViewController", bundle: Bundle(for: CalendarViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        didSelect(date.toString(format: "yyyy-MM-dd"))
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        if let date = self.date {
            return date
        }else {
            return Date()
        }
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
