//
//  ProgreamParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

class ProgramParser: NSObject, XMLParserDelegate {
    
    weak private var parent: XMLParserDelegate?
    
    private var builder : Program.Builder = Program.Builder()
    
    private let parsedProgram : PublishSubject<Program> = PublishSubject<Program>()
    
    private var parsingElement : String? = nil
    
    init(parent: XMLParserDelegate, startTime: Date, endTime: Date) {
        self.parent = parent
        builder = builder.start(from : startTime).end(at : endTime)
    }
    
    func observeProgramParseComplete() -> Observable<Program> {
        return parsedProgram.asObserver()
    }
    
    private var parsingData : String?
    
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String : String]) {
        parsingElement = elementName
        switch elementName {
        case "title", "img", "pfm", "desc", "info", "url":
            parsingData = ""
            break
        case "meta":
            if let name = attributeDict["name"], let value = attributeDict["value"] {
                builder = builder.addMeta(name: name, value: value)
            }
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        if let _ = parsingData {
            parsingData?.append(string)
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        switch elementName {
        case "title":
            builder = builder.title(title: parsingData!)
            break
        case "pfm":
            builder = builder.personality(personality: parsingData!)
            break
        case "desc":
            builder = builder.description(description: parsingData!)
            break
        case "info":
            builder = builder.info(info: parsingData!)
            break
        case "url":
            builder = builder.url(url: parsingData!)
            break
        case "img":
            builder = builder.image(image: parsingData!)
            break
        case "prog":
            parsedProgram.onNext(builder.build()!)
            parser.delegate = parent
            break
        default:
            break
        }
        parsingData = nil
        parsingElement = nil
    }
}
