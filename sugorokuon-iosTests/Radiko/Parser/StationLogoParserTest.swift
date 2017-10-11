//
//  StationLogoParserTest.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/04.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import XCTest
import RxSwift

class StationLogoParserTest: XCTestCase {
    
    
    class MyParserDelegate : NSObject, XMLParserDelegate {
        
        var completed = false
        
        public func parserDidEndDocument(_ parser: XMLParser) {
            completed = true
        }
        
        // メモ : startとend の間に特定の parser が機能するように parser.delegate を差し替えながら進んでいく
        // Startion parser みたいなやつをまずはつくるのかしら
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            
            print("parsing : \(elementName)")
            print(" attributes")
            attributeDict.forEach { attr in
                print("   \(attr)")
            }
            
            //        if (elementName == "logo") {
            //            parser.delegate = StationLogoParser()
            //        }
            
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            print("end parsing : \(elementName)")
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            print(" value - \(string)") // TBS ラジオ がTBSとラジオで別れちゃうので、
        }
        
        func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
            print(" white spacestring : \(whitespaceString)")
        }
        
        
        func parser(parser: XMLParser,didStartElement elementName: String,namespaceURI: String?,qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject])
        {
            print(elementName)
        }
        
    }

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let testSingle: Single<String> =  Single<String>.just("aaa")
        
        let disposables = DisposeBag()
        testSingle.subscribe(
            onSuccess: { str in
                XCTAssertEqual("aaa", str)
        },
            onError: { e in
                XCTAssertTrue(false, "xxxx")
        }).addDisposableTo(disposables)
    }
    
    func testParse() {
        let url = URL(string: "http://radiko.jp/v2/station/list/JP13.xml")!
        let parser: XMLParser? = XMLParser(contentsOf: url)
        //var parser: XMLParser? = XMLParser(data: xml.data(using: .utf8)!)
        
        let d = MyParserDelegate()
        parser!.delegate = d
        parser!.parse()
        
        XCTAssertTrue(d.completed)
    }

    
}
