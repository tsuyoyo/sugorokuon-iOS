//
//  StationFetcher.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/03.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

public class StationParser: NSObject, XMLParserDelegate {

    weak private var parent: XMLParserDelegate?
    
    private let disposeBag = DisposeBag()
    private var builder: Station.Builder = Station.Builder()
    private var parsingElement: String?
    private var logoParser: StationLogoParser?
    
    private let parsedStation: PublishSubject<Station> = PublishSubject<Station>()
    
    init(parent: XMLParserDelegate) {
        self.parent = parent
    }
    
    func obeserveStationParseComplete() -> Observable<Station> {
        return parsedStation.asObserver()
    }
    
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String : String]) {
        
        switch (elementName) {
        case "logo":
            if let w = attributeDict["width"],
                let h = attributeDict["height"] {
                logoParser = StationLogoParser(parent: self)
                logoParser?.setSize(width: Int(w)!, height: Int(h)!)
                logoParser?
                    .observeLogoParseComplete()
                    .subscribe(onLogoParsed)
                    .addDisposableTo(disposeBag)
                parser.delegate = logoParser
            }
            break
        default:
            break
        }
        
        parsingElement = elementName
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let element = parsingElement {
            switch (element) {
            case "id":
                builder = builder.id(id: string)
                break
            case "name":
                builder = builder.name(name: string)
                break
            case "ascii_name":
                builder = builder.asciiName(asciiName: string)
                break
            case "href":
                builder = builder.siteUrl(siteUrl: string)
                break
            case "logo_large":
                builder = builder.logoUrl(logoUrl: string)
                break
            case "feed":
                builder = builder.feed(feed: string)
                break
            case "banner":
                builder = builder.bannerUrl(bannerUrl: string)
                break
            default:
                break;
            }
        }
    }
    
    public func parser(_ parser: XMLParser,
                       didEndElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?) {
        switch elementName {
        case "station":
            parsedStation.onNext(builder.build())
            parser.delegate = parent
            break;
        default:
            parsingElement = nil
            break;
        }
    }
    
    private func onLogoParsed(event : RxSwift.Event<StationLogo>) -> Void {
        if let stationLogo = event.element {
            builder = builder.addLogo(logo: stationLogo)
        }
    }
    
}
