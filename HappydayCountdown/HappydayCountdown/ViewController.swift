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
        
        bindData()
    }
    
    private func bindData() {
        Utilities.shared.todayDate = { [weak self] dateToday -> String in
            guard let self = self else {
                return dateToday
            }
            
            self.today.text = dateToday
            return dateToday
        }
        
        Utilities.shared.nextMoneyDate = { [weak self] dateNextMoney -> String in
            guard let self = self else {
                return dateNextMoney
            }
            
            self.nextMoneyDay.text = dateNextMoney
            return dateNextMoney
        }
        
        Utilities.shared.toNextMoneyDays = { [weak self] daysToNextMoney -> String in
            guard let self = self else {
                return daysToNextMoney
            }
            
            self.nextMoneyCountdown.text = daysToNextMoney
            return daysToNextMoney
        }
        
        Utilities.shared.nextLongHolidayDate = { [weak self] dateNextLongHoliday -> String in
            guard let self = self else {
                return dateNextLongHoliday
            }
            
            self.nextLongHoliday.text = dateNextLongHoliday
            return dateNextLongHoliday
        }
        
        Utilities.shared.toNextLongHolidayDaysTitle = { [weak self] titleToNextLongHoliday -> String in
            guard let self = self else {
                return titleToNextLongHoliday
            }
            
            self.nextLongHolidayTitle.text = titleToNextLongHoliday
            return titleToNextLongHoliday
        }
        
        Utilities.shared.toNextLongHolidayDays = { [weak self] daysToNextLongHoliday -> String in
            guard let self = self else {
                return daysToNextLongHoliday
            }
            
            self.nextLongHolidayCountdown.text = daysToNextLongHoliday
            return daysToNextLongHoliday
        }
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


