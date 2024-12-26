//
//  DatePickerPopUPController.swift
//  SAN SALES
//
//  Created by Anbu j on 19/12/24.
//

import UIKit

class DatePickerPopUPController: UIViewController {
    
    @IBOutlet weak var time_picker: UIDatePicker!
    
    var didSelect : (String) -> () = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePicker()
    }
    
    
    private func setupDatePicker() {
            // Set the date picker mode to time
            time_picker.datePickerMode = .time
            
            // Set a default date (current date)
            time_picker.date = Date()
            
            // Optionally configure minimum and maximum time (e.g., restrict to +/- 12 hours from now)
            time_picker.minimumDate = Calendar.current.date(byAdding: .hour, value: -12, to: Date())
            time_picker.maximumDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
            
            // Add a target-action to handle value changes
            time_picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            
            // For iOS 13.4 and above, you can specify the picker style
            if #available(iOS 13.4, *) {
                time_picker.preferredDatePickerStyle = .wheels
            }
        }
    
    // Action called when the UIDatePicker value changes
      @objc func datePickerValueChanged(_ sender: UIDatePicker) {
          let formatter = DateFormatter()
          formatter.timeStyle = .short // Display time in "hh:mm a" format (e.g., "10:30 AM")
          let selectedTime = formatter.string(from: sender.date)
     
          print(selectedTime)
          didSelect(selectedTime)
      }
    
    
    init() {
        super.init(nibName: "DatePickerPopUPController", bundle: Bundle(for: DatePickerPopUPController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func OK(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
