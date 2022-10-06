//
//  Utilities.swift
//  HappydayCountdown
//
//  Created by tpi on 2022/9/16.
//

import UIKit

import RxSwift
import RxRelay

class Utilities {
    static let shared = Utilities()
    
    var moneyDay: Int
    
    var todayDate = PublishSubject<String>()
    var nextMoneyDate = PublishSubject<String>()
    var toNextMoneyDays = PublishSubject<String>()
    var nextLongHolidayDate = PublishSubject<String>()
    var toNextLongHolidayDaysTitle = PublishSubject<String>()
    var toNextLongHolidayDays = PublishSubject<String>()
    
    init(moneyGetDay: Int = 5) {
        moneyDay = moneyGetDay
        _ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.computeAllDayData()
        }
    }
    
    func computeAllDayData() {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "M 月 d 日"
        
        let dateToday = Utilities.shared.dateAndcomponentFromDateWithNoTime().date
        let todayComponent = dateToday.clearedTimeDateAndComponent().components
        guard let todayDay = todayComponent.day else {
            fatalError("No day value due to the dateComponents failure.")
        }
        todayDate.onNext(dateFormatter.string(from: Date()))
        saveStringToUserDefault(content: dateFormatter.string(from: Date()), theKey: .todayDate)
        
        let addMonth = todayDay > moneyDay ? 1 : 0
        var nextMoneyComponent = Utilities.shared.dateAndcomponentFromDateWithNoTime(date: dateToday, addMonth: addMonth).components
        nextMoneyComponent.day = moneyDay
        
        let dateForNextMoney = nextMoneyComponent.clearedTimeDateAndComponent().date
        guard let daysToNextMoneyDate = Calendar.current.dateComponents([.day], from: todayComponent, to: nextMoneyComponent).day else {
            fatalError("Cannot compute the days due to the moneyday components failure.")
        }
        nextMoneyDate.onNext(dateFormatter.string(from: dateForNextMoney))
        toNextMoneyDays.onNext("\(daysToNextMoneyDate) 天")
        saveStringToUserDefault(content: dateFormatter.string(from: dateForNextMoney), theKey: .nextMoneyDate)
        saveStringToUserDefault(content: "\(daysToNextMoneyDate) 天", theKey: .toNextMoneyDays)
        
        let holidayComponents = [Utilities.shared.holidaySetup(month: 1, day: 29),
                                 Utilities.shared.holidaySetup(month: 2, day: 26),
                                 Utilities.shared.holidaySetup(month: 4, day: 2),
                                 Utilities.shared.holidaySetup(month: 4, day: 30),
                                 Utilities.shared.holidaySetup(month: 6, day: 3),
                                 Utilities.shared.holidaySetup(month: 9, day: 9),
                                 Utilities.shared.holidaySetup(month: 10, day: 8),
                                 Utilities.shared.holidaySetup(month: 12, day: 31)]
        
        for holidayComponent in holidayComponents {
            guard let nextHolidayDateTime = holidayComponent.date else {
                fatalError("Next holiday date parsing from the component failure.")
            }
            let currentDateTime = Date()
            if nextHolidayDateTime.timeIntervalSinceReferenceDate - currentDateTime.timeIntervalSinceReferenceDate > 0 {
                guard let holiday = holidayComponent.date else {
                    fatalError("Holiday components failure.")
                }
                var minusHolidayComponent = DateComponents()
                minusHolidayComponent.hour = -6

                guard let adjustedHolidayDateForComputing = Calendar.current.date(byAdding: minusHolidayComponent, to: holiday) else {
                    fatalError("Adjusted holiday date failure.")
                }
                let countdownComponentsToNextLongHoliday = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDateTime, to: adjustedHolidayDateForComputing)
                guard let day = countdownComponentsToNextLongHoliday.day, let hour = countdownComponentsToNextLongHoliday.hour, let minute = countdownComponentsToNextLongHoliday.minute, let second = countdownComponentsToNextLongHoliday.second else {
                    fatalError("Countdown components failure.")
                }
                let countdownString = "\(day) 天 \(hour) 小時 \(minute) 分 \(second) 秒"
                
                nextLongHolidayDate.onNext(dateFormatter.string(from: nextHolidayDateTime))
                toNextLongHolidayDaysTitle.onNext("下次連假倒數")
                toNextLongHolidayDays.onNext(countdownString)
                saveStringToUserDefault(content: dateFormatter.string(from: nextHolidayDateTime), theKey: .nextLongHolidayDate)
                saveStringToUserDefault(content: "下次連假倒數", theKey: .toNextLongHolidayDaysTitle)
                saveStringToUserDefault(content: "\(day) 天 \(hour) 小時 \(minute) 分", theKey: .toNextLongHolidayDays)
                
                return
            }
        }
        
        nextLongHolidayDate.onNext("沒連假惹")
        toNextLongHolidayDaysTitle.onNext("離職倒數？")
        toNextLongHolidayDays.onNext("1 天")
        saveStringToUserDefault(content: "沒連假惹", theKey: .nextLongHolidayDate)
        saveStringToUserDefault(content: "離職倒數？", theKey: .toNextLongHolidayDaysTitle)
        saveStringToUserDefault(content: "1 天", theKey: .toNextLongHolidayDays)
    }
    
    private func dateAndcomponentFromDateWithNoTime(date: Date = Date(), addYear: Int = 0, addMonth: Int = 0, addDay: Int = 0) -> (date: Date, components: DateComponents) {
        var dateComponentForAdd = DateComponents()
        dateComponentForAdd.year = addYear
        dateComponentForAdd.month = addMonth
        dateComponentForAdd.day = addDay
        
        guard let adjustedDate = Calendar.current.date(byAdding: dateComponentForAdd, to: date) else {
            return (date, Calendar.current.dateComponents(in: .current, from: date))
        }
        
        return (adjustedDate.clearedTimeDateAndComponent().date, adjustedDate.clearedTimeDateAndComponent().components)
    }
    
    private func holidaySetup(month: Int, day: Int) -> DateComponents {
        var holidayComponent = Calendar.current.dateComponents(in: .current, from: Date())
        holidayComponent.month = month
        holidayComponent.day = day
        holidayComponent.hour = 0
        holidayComponent.minute = 0
        holidayComponent.second = 0
        holidayComponent.nanosecond = 0
        
        return holidayComponent.clearedTimeDateAndComponent().components
    }
    
    private func saveStringToUserDefault(content: String, theKey: UserDefaultKeys) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(content, forKey: theKey.rawValue)
        userDefault.synchronize()
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
