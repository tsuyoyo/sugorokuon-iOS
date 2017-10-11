//
//  NowOnAirItemParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/01.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

//<item amazon=""
//    artist="TIN PAN ALLEY"
//    evid=""
//    img=""
//    img_large=""
//    itemid="cdc0b8c329b5b19d"
//    itunes=""
//    program_title="Music Insurance〜音楽は心の保険〜"
//    recochoku=""
//    stamp="2017-10-01 21:36:54"
//    title="航海日誌"/>
//
class NowOnAirParser: NSObject, XMLParserDelegate {
    
    private var parsedItems: Array<OnAirSong> = []
    
    private var parsedItemSubject: BehaviorSubject<Array<OnAirSong>> = BehaviorSubject<Array<OnAirSong>>(value: [])
    
    func getParsedItem() -> Array<OnAirSong> {
        return parsedItems
    }
    
    func observeNowOnAirParsed() -> Observable<Array<OnAirSong>> {
        return parsedItemSubject.asObservable()
    }
    
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String : String]) {
        if elementName == "item" {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            parsedItems.append(OnAirSong(
                title: attributeDict["title"]!,
                artist: attributeDict["artist"]!,
                onAirTime: formatter.date(from: attributeDict["stamp"]!)!,
                image: attributeDict["img"],
                amazon: attributeDict["amazon"],
                iTunes: attributeDict["iTunes"],
                recochoku: attributeDict["recochoku"]))
        }
    }
    
    private func parseDate(from: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: from)!
    }
    
    public func parser(_ parser: XMLParser,
                       didEndElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?) {
        if elementName == "noa" {
            parsedItemSubject.onNext(parsedItems)
        }
    }
    
}
