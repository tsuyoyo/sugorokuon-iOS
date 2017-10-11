//
//  StationResponseParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/17.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

class StationResponseParser: NSObject, XMLParserDelegate {
    
    private let urlManager : UrlManager
    private let disposeBag = DisposeBag()
    private var stations = Array<Station>()
    private var stationParser: StationParser?
    private let parsedResult: BehaviorSubject<Array<Station>> = BehaviorSubject<Array<Station>>(value: [])
    
    init(urlManager : UrlManager) {
        self.urlManager = urlManager
    }
    
    public func parsedStations() -> Observable<Array<Station>> {
        return parsedResult.asObserver()
            .filter({ stations -> Bool in
                return !stations.isEmpty
            })
    }
    
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String : String] = [:]) {
        if elementName == "station" {
            handleStationElement(parser: parser)
        }
    }
    
    public func parser(_ parser: XMLParser,
                       didEndElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?) {
        if elementName == "stations" {
            parsedResult.onNext(stations)
        }
    }
    
    func getStations() -> Array<Station> {
        return stations
    }
    
    private func handleStationElement(parser: XMLParser) {
        stationParser = StationParser(parent: self)
        stationParser?
            .obeserveStationParseComplete()
            .subscribe(onStationParsed)
            .addDisposableTo(disposeBag)
        
        parser.delegate = stationParser
    }
    
    private func onStationParsed(event : RxSwift.Event<Station>) -> Void {
        if let station = event.element {
            print("\(station.name) is onNext, having \(station.logos.count) logos")
            stations.append(station)
        }
    }

}
