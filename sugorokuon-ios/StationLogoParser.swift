//
//  StationLogoParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/04.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

class StationLogoParser: NSObject, XMLParserDelegate {
    
    weak private var parent: XMLParserDelegate?
    
    private var builder : StationLogo.Builder = StationLogo.Builder()
    
    private let parsedLogo : PublishSubject<StationLogo> = PublishSubject<StationLogo>()
    
    init(parent: XMLParserDelegate) {
        self.parent = parent
    }
    
    func setSize(width: Int, height: Int) {
        builder = builder
            .width(width: width)
            .height(height: height)
    }
    
    func observeLogoParseComplete() -> Observable<StationLogo> {
        return parsedLogo.asObserver()
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        builder = builder.url(url: string)
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if let p = parent {
            parsedLogo.onNext(builder.build())
            parser.delegate = p
        }
    }
}
