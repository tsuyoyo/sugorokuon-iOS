//
//  DateSelectViewController.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/27.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit

protocol DateSelectorViewControllerDelegate {
    func onDateSelected(date : Date)
}

class DateSelectViewController: UIViewController {
    
    var delegate : DateSelectorViewControllerDelegate!
    
    private var date : Date!
    
    @IBOutlet weak var datePicker: UIDatePicker!

    func set(date : Date) {
        self.date = date
    }
    
    func getDate() -> Date {
        return date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setDate(date, animated: false)
        datePicker.minimumDate = Calendar.current.date(
            byAdding: .day,
            value: -7,
            to: Date()
        )
        datePicker.maximumDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: Date()
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSelectCliecked(_ sender: Any) {
        delegate?.onDateSelected(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
