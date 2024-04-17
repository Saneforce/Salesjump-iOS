//
//  TourPlanCalenderScreen.swift
//  SAN SALES
//
//  Created by Naga Prasath on 16/04/24.
//

import Foundation
import UIKit
import FSCalendar



class TourPlanCalenderScreen : UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.addTarget(target: self, action: #selector(backVC))
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbTourPlanSingleEntry") as!  TourPlanSingleEntry
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
