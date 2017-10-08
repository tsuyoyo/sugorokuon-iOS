//
//  TimeTableApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/01.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

class TimeTableApi {
    
    private let urlManager: UrlManager
    
    init (urlManager: UrlManager) {
        self.urlManager = urlManager
    }
    
    func fetchTimeTable(region id: String, date : Date) -> Observable<Array<TimeTable>>{
        let url = URL(string: urlManager.timeTable(date: date, region: id))!
        let parser = XMLParser(contentsOf: url)!
        
        let parserDelegate = OneDayTimeTableParser()
        parser.delegate = parserDelegate
        
        let observer = parserDelegate.observeTodayTimeTableParsed()
//            .filter { timeTable -> Bool in
//                return !timeTable.isEmpty
//            }
//            .flatMapFirst({ timeTable -> Maybe<Array<TimeTable>> in
//                return Maybe.just(timeTable)
//            })
//            .map { timeTable -> Array<TimeTable> in
//                return timeTable
//            }
//
//            .asMaybe()
//
//            .map { timeTable -> Array<TimeTable> in
//                return timeTable
//            }
        parser.parse()
        return observer
    }
}
