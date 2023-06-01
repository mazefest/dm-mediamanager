//
//  DatePickerViewController.swift
//  MediaManager
//
//  Created by Colby Mehmen on 6/1/23.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
   func reminderDateEdited(date: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date: Date?
    weak var delegate: DatePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.date = sender.date
    }
    
    @IBAction func onSaveButtonTapped(_ sender: Any) {
        guard let delegate = delegate,
           let date = self.date else { return }
        delegate.reminderDateEdited(date: date)
        navigationController?.popViewController(animated: true)
    }
}
