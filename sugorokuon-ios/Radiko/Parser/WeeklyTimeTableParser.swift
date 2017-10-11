//
//  WeeklyTimeTableParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

class WeeklyTimeTableParser : NSObject, XMLParserDelegate {

    private var stationId : String?
    private let disposeBag = DisposeBag()
    private let parsedTimeTables = PublishSubject<Array<TimeTable>>()
    private var timeTableParser : TimeTableParser?
    private var timeTables = Array<TimeTable>()
        
    public func observeWeeklyTimeTableParsed() -> Observable<Array<TimeTable>> {
        return parsedTimeTables.asObserver()
    }
    
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String : String]) {
        switch elementName {
        case "station":
            stationId = attributeDict["id"]
            break
        case "progs":
            timeTableParser = TimeTableParser(stationId: stationId!, parent: self)
            timeTableParser?
                .observeParsedTimeTable()
                .subscribe(onTimeTableParsed)
                .addDisposableTo(disposeBag)
            parser.delegate = timeTableParser!
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        switch elementName {
        case "scd":
            parsedTimeTables.onNext(timeTables)
            break;
        default:
            break;
        }
    }
    
    private func onTimeTableParsed(event : RxSwift.Event<TimeTable>) -> Void {
        if let timeTable = event.element {
            timeTables.append(timeTable)
        }
    }
}
