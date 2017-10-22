//
//  RadikoDateUtil.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/22.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class RadikoDateUtil {
    
    /**
     * On timetable, 1 day is from 5:00am to 29:59.
     * E.g. when now is 1/10 1:30am, then the date is 1/9.
     */
    func getToday() -> Date {
        let now = Calendar.current.dateComponents([.hour, .day], from: Date())

        let gregorian = Calendar(identifier: .gregorian)

        var components = gregorian.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: Date())
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if now.hour! < 5 {
            components.day = now.day! - 1
        } else {
            components.day = now.day!
        }
        
        return gregorian.date(from: components)!
    }
    
    func isToday(date: Date) -> Bool {
        let now = Calendar.current.dateComponents([.hour, .day], from: Date())
        let d = Calendar.current.dateComponents([.hour, .day], from: date)
        
        // from 5:00 to 24:00
        if (now.date! == d.date!) && (d.hour! >= 5) {
            return true
        }
        // from 25:00 to 29:59
        if (now.date! == d.date! - 1) && d.hour! <= 5 {
            return true
        }
        return false
    }
    
    func isNowOnAir(program: Program) -> Bool {
        let now = Date()
        return now > program.startTime && now < program.endTime
    }

}
