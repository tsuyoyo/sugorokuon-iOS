//
//  TimeTableRepository.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

class TimeTableRepository {
    
    enum Error : Swift.Error, CustomDebugStringConvertible {
        var debugDescription: String {
            switch self {
            case .noElements:
                return "No timeTable"
            }
        }
        case noElements
    }
    
    private var timeTables : Dictionary = [String : Array<TimeTable>]()
    
    func store(station id : String, timeTables: Array<TimeTable>) -> Void {
        self.timeTables[id] = timeTables
    }

    func load(station id: String, day : Week) -> Single<TimeTable> {

        return Observable.from(timeTables)
            // find timeTables for the station
            .filter({ (t : (key: String, value: Array<TimeTable>)) -> Bool in
                return t.key == id
            })
            // transfer stream from (stationId, timeTables) to timeTable
            .flatMap({ (t : (key: String, value: Array<TimeTable>)) -> Observable<TimeTable> in
                return Observable.from(t.value)
            })
            // find timeTable for the day
            .filter({ (t) -> Bool in
                let timeTableDay = Calendar(identifier: .gregorian).component(.weekday, from: t.date)
                return day.hashValue == timeTableDay
            })
            .ifEmpty(switchTo: Observable.error(Error.noElements))
            .asSingle()
    }
    
}
