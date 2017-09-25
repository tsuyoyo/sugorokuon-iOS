//
//  TimeTableParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

class TimeTableParser: NSObject, XMLParserDelegate {
    
    weak private var parent: XMLParserDelegate?
    private let disposeBag = DisposeBag()
    
    private let parsedTimeTable : PublishSubject<TimeTable> = PublishSubject<TimeTable>()
    
    private let stationId : String
    private var date: Date?
    private var programs : Array<Program> = Array<Program>()
    
    private var parsingElement: String?
    private var programParser : ProgramParser?
    
    init (stationId : String, parent: XMLParserDelegate) {
        self.stationId = stationId
        self.parent = parent
    }
    
    public func observeParsedTimeTable () -> Observable<TimeTable> {
        return parsedTimeTable.asObserver()
    }
    
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String : String]) {
        switch elementName {
        case "date":
            parsingElement = elementName
            break;
        case "prog":
            //<prog ft="20170904050000" to="20170904070000" ftl="0500" tol="0700" dur="7200">
            if let start = attributeDict["ft"], let end = attributeDict["to"] {
                programParser = ProgramParser(
                    parent: self,
                    startTime: parseDate(from: start, format: "yyyyMMddHHmmss"),
                    endTime: parseDate(from: end, format: "yyyyMMddHHmmss"))
                
                programParser?
                    .observeProgramParseComplete()
                    .subscribe(onProgramParsed)
                    .addDisposableTo(disposeBag)
                
                parser.delegate = programParser
            }
            break;
        default:
            break;
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        if parsingElement == "date" {
            date = parseDate(from: string, format: "yyyyMMdd")
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        switch elementName {
        case "progs":
            parsedTimeTable.onNext(TimeTable(
                stationId: stationId,
                date: date!,
                programs: programs))
            parser.delegate = parent
            break;
        case "date":
            parsingElement = nil
            break;
        default:
            break;
        }
    }
    
    private func parseDate(from: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: from)!
    }
    
    private func onProgramParsed(event : RxSwift.Event<Program>) -> Void {
        if let p = event.element {
            programs.append(p)
        }
    }
    
}
