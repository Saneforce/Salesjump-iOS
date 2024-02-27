//
//  ManagerDashboard.swift
//  SAN SALES
//
//  Created by San eforce on 16/11/23.
//

import UIKit
import Parchment

class ManagerDashboard: UIViewController{

    @IBOutlet weak var BackBT: UIImageView!
    
       override func viewDidLoad(){
           super.viewDidLoad()
           PageView()
           BackBT.addTarget(target: self, action: #selector(GotoHome))
       }
    func PageView(){
        let storyboard = UIStoryboard(name: "ManagerDashboard", bundle: nil)
        let AttendanceViewController = storyboard.instantiateViewController(withIdentifier: "Attendance")
        let SummaryViewController = storyboard.instantiateViewController(withIdentifier: "Summary")
        let PerformanceViewController = storyboard.instantiateViewController(withIdentifier: "Performance")
        let LocationViewController = storyboard.instantiateViewController(withIdentifier: "Location")
        let CoverageViewController = storyboard.instantiateViewController(withIdentifier: "Coverage")

        let pagingViewController = PagingViewController(viewControllers: [
         AttendanceViewController,
         PerformanceViewController,
         SummaryViewController,
         LocationViewController,
         CoverageViewController,
            
        ])
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    @objc private func GotoHome() {
        navigationController?.popViewController(animated: true)
    }
   }
