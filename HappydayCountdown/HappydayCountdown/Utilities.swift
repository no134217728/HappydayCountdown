//
//  Utilities.swift
//  HappydayCountdown
//
//  Created by tpi on 2022/9/16.
//

import UIKit

class Utilities {
    static let shared = Utilities()
    
    var moneyDay: Int
    
    init(moneyGetDay: Int = 5) {
        moneyDay = moneyGetDay
        let timer = Timer(fireAt: Date(), interval: 60, target: self, selector: #selector(computeAllDayData), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func computeAllDayData() {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "M 月 d 日"
                
        let todayDate = Utilities.shared.dateAndcomponentFromDateWithNoTime().date
        let todayComponent = todayDate.clearedTimeDateAndComponent().components
        guard let todayDay = todayComponent.day else {
            fatalError("No day value due to the dateComponents failure.")
        }
        saveStringToUserDefault(content: dateFormatter.string(from: todayDate), theKey: .todayDate)
        
        let addMonth = todayDay > moneyDay ? 1 : 0
        var nextMoneyComponent = Utilities.shared.dateAndcomponentFromDateWithNoTime(date: todayDate, addMonth: addMonth).components
        nextMoneyComponent.day = moneyDay
        
        let nextMoneyDate = nextMoneyComponent.clearedTimeDateAndComponent().date
        guard let toNextMoneyDays = Calendar.current.dateComponents([.day], from: todayComponent, to: nextMoneyComponent).day else {
            fatalError("Cannot compute the days due to the moneyday components failure.")
        }
        saveStringToUserDefault(content: dateFormatter.string(from: nextMoneyDate), theKey: .nextMoneyDate)
        saveStringToUserDefault(content: "\(toNextMoneyDays) 天", theKey: .toNextMoneyDays)
        
        let holidayComponents = [Utilities.shared.holidaySetup(month: 1, day: 29),
                                 Utilities.shared.holidaySetup(month: 2, day: 26),
                                 Utilities.shared.holidaySetup(month: 4, day: 2),
                                 Utilities.shared.holidaySetup(month: 4, day: 30),
                                 Utilities.shared.holidaySetup(month: 6, day: 3),
                                 Utilities.shared.holidaySetup(month: 9, day: 9),
                                 Utilities.shared.holidaySetup(month: 10, day: 8),
                                 Utilities.shared.holidaySetup(month: 12, day: 31)]
        saveStringToUserDefault(content: "沒連假惹", theKey: .nextLongHolidayDate)
        saveStringToUserDefault(content: "離職倒數？", theKey: .toNextLongHolidayDaysTitle)
        saveStringToUserDefault(content: "1 天", theKey: .toNextLongHolidayDays)
        
        for holidayComponent in holidayComponents {
            guard let toNextLongHolidayDays = Calendar.current.dateComponents([.day], from: todayComponent, to: holidayComponent).day else {
                fatalError("Cannot compute the days due to the holiday components failure.")
            }
            if toNextLongHolidayDays >= 0 {
                let nextLongHolidayDate = holidayComponent.clearedTimeDateAndComponent().date
                saveStringToUserDefault(content: dateFormatter.string(from: nextLongHolidayDate), theKey: .nextLongHolidayDate)
                saveStringToUserDefault(content: "連假倒數", theKey: .toNextLongHolidayDaysTitle)
                saveStringToUserDefault(content: "\(toNextLongHolidayDays) 天", theKey: .toNextLongHolidayDays)
                
                break
            }
        }
    }
    
    func dateAndcomponentFromDateWithNoTime(date: Date = Date(), addYear: Int = 0, addMonth: Int = 0, addDay: Int = 0) -> (date: Date, components: DateComponents) {
        var dateComponentForAdd = DateComponents()
        dateComponentForAdd.year = addYear
        dateComponentForAdd.month = addMonth
        dateComponentForAdd.day = addDay
        
        guard let adjustedDate = Calendar.current.date(byAdding: dateComponentForAdd, to: date) else {
            return (date, Calendar.current.dateComponents(in: .current, from: date))
        }
        
        return (adjustedDate.clearedTimeDateAndComponent().date, adjustedDate.clearedTimeDateAndComponent().components)
    }
    
    func holidaySetup(month: Int, day: Int) -> DateComponents {
        var holidayComponent = Calendar.current.dateComponents(in: .current, from: Date())
        holidayComponent.month = month
        holidayComponent.day = day
        holidayComponent.hour = 0
        holidayComponent.minute = 0
        holidayComponent.second = 0
        holidayComponent.nanosecond = 0
        
        return holidayComponent.clearedTimeDateAndComponent().components
    }
    
    func saveStringToUserDefault(content: String, theKey: UserDefaultKeys) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(content, forKey: theKey.rawValue)
    }
    
    func takeStringFromUserDefault(theKey: UserDefaultKeys) -> String {
        let userDefault = UserDefaults.standard
        return userDefault.string(forKey: theKey.rawValue) ?? ""
    }
}

enum UserDefaultKeys: String {
    case todayDate = "TodayDate"
    
    case nextMoneyDate = "NextMoneyDate"
    case toNextMoneyDays = "ToNextMoneyDays"
    
    case nextLongHolidayDate = "NextLongHolidayDate"
    case toNextLongHolidayDays = "ToNextLongHolidayDays"
    case toNextLongHolidayDaysTitle = "ToNextLongHolidayDaysTitle"
}
