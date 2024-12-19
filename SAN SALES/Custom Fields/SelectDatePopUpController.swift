//
//  SelectDatePopUpController.swift
//  SAN SALES
//
//  Created by Anbu j on 19/12/24.
//

import UIKit
import FSCalendar

class SelectDatePopUpController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var Calendar: FSCalendar!
    var didSelect : (String) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        Calendar.layer.cornerRadius = 8
        Calendar.delegate = self
        Calendar.dataSource = self

    }
    
    init() {
        super.init(nibName: "SelectDatePopUpController", bundle: Bundle(for: SelectDatePopUpController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        didSelect(date.toString(format: "yyyy-MM-dd"))
        self.dismiss(animated: true)
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
}
