//
//  ViewController.swift
//  HappydayCountdown
//
//  Created by Wei Jen Wang on 2022/9/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var nextMoneyDay: UILabel!
    @IBOutlet weak var nextMoneyCountdown: UILabel!
    @IBOutlet weak var nextLongHoliday: UILabel!
    @IBOutlet weak var nextLongHolidayTitle: UILabel!
    @IBOutlet weak var nextLongHolidayCountdown: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        today.text = ""
        nextMoneyDay.text = ""
        nextMoneyCountdown.text = ""
        nextLongHoliday.text = ""
        nextLongHolidayCountdown.text = ""
    }
    
    @objc func becomeActive(_ notification: Notification)  {
        today.text = Utilities.shared.takeStringFromUserDefault(theKey: .todayDate)
        nextMoneyDay.text = Utilities.shared.takeStringFromUserDefault(theKey: .nextMoneyDate)
        nextMoneyCountdown.text = Utilities.shared.takeStringFromUserDefault(theKey: .toNextMoneyDays)
        nextLongHoliday.text = Utilities.shared.takeStringFromUserDefault(theKey: .nextLongHolidayDate)
        nextLongHolidayTitle.text = Utilities.shared.takeStringFromUserDefault(theKey: .toNextLongHolidayDaysTitle)
        nextLongHolidayCountdown.text = Utilities.shared.takeStringFromUserDefault(theKey: .toNextLongHolidayDays)
    }
}


