//
//  Extensions.swift
//  HappydayCountdown
//
//  Created by tpi on 2022/9/16.
//

import Foundation

extension DateComponents {
    func clearedTimeDateAndComponent() -> (date: Date, components: Self) {
        var dateComp = self
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        dateComp.nanosecond = 0
        
        guard let clearedTimeDate = dateComp.date else {
            fatalError("Fail to convert date and components.")
        }
        
        return (clearedTimeDate, dateComp)
    }
}

extension Date {
    func clearedTimeDateAndComponent() -> (date: Self, components: DateComponents) {
        let dateComp = Calendar.current.dateComponents(in: .current, from: self)
        
        return (dateComp.clearedTimeDateAndComponent().date, dateComp.clearedTimeDateAndComponent().components)
    }
}
