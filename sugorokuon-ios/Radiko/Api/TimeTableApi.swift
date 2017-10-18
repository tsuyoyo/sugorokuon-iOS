//
//  TimeTableApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/01.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TimeTableApi {
    
    private let urlManager: UrlManager
    
    init (urlManager: UrlManager) {
        self.urlManager = urlManager
    }
    
    func fetchTimeTable(region id: String, date : Date) -> Observable<Array<TimeTable>> {
        let url = URL(string: urlManager.timeTable(date: date, region: id))!
        return URLSession.shared
            .rx
            .response(request: URLRequest(url: url))
            .flatMap({ (_, data) -> Observable<Array<TimeTable>> in
                let parser = XMLParser(contentsOf: url)!
                let parserDelegate = OneDayTimeTableParser()
                parser.delegate = parserDelegate
                
                let observable = parserDelegate.observeTodayTimeTableParsed()
                parser.parse()
                return observable
            })
    }
}
