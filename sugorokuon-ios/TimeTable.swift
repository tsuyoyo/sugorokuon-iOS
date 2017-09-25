//
//  TimeTable.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

/**
 * One day/One station time table.
 *
 */
class TimeTable {
    
    init (stationId : String, date : Date, programs : Array<Program>) {
        self.stationId = stationId
        self.date = date
        self.programs = programs
    }
    
    let stationId : String
    let date : Date
    let programs : Array<Program>
    
}
