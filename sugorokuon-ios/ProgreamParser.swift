//
//  ProgreamParser.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/16.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import UIKit
import RxSwift

//<prog id="8710171067" master_id="" ft="20170917100000" to="20170917103000" ftl="1000" tol="1030" dur="1800">
//<title>鎌田實×村上信夫　日曜はがんばらない</title>
//<url>http://www.joqr.co.jp/kamata/</url>
//<failed_record>0</failed_record>
//<ts_in_ng>0</ts_in_ng>
//<ts_out_ng>0</ts_out_ng>
//<desc/>
//<info>
//<img src='http://www.joqr.co.jp/qr_img/detail_re/20120409124840.jpg' style="max-width: 200px;"> <br /><br /><br/>番組メールアドレス：<br/><a href="mailto:kamata@joqr.net">kamata@joqr.net</a><br/>番組Webページ：<br/><a href="http://www.joqr.co.jp/kamata/">http://www.joqr.co.jp/kamata/</a><br/><br/>毎日毎日がんばっているあなた。日曜くらいは、がんばるのをやめてみませんか？「日曜はがんばらない」日曜の朝のひととき、「いのち」が喜ぶ時間にしてみませんか？がんばらない医師の鎌田實と、ついついがんばってしまう村上信夫がお送りします。<br/><br/>twitterハッシュタグは「<a href="http://twitter.com/#!/search/%23joqr">#joqr</a>」<br/>twitterアカウントは「<a href="http://twitter.com/#!/ganbaranai1134">@ganbaranai1134</a>」<br/>facebookページは「<a href='http://www.facebook.com/1134joqr'>http://www.facebook.com/1134joqr</a>」<br/>
//</info>
//<pfm>鎌田實　村上信夫</pfm>
//<img>
//https://radiko.jp/res/program/DEFAULT_IMAGE/QRR/cl_20160930214315_1916464.png
//</img>
//<metas>
//<meta name="twitter" value="#joqr"/>
//<meta name="twitter" value="from:ganbaranai1134"/>
//</metas>
//</prog>

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
        case "title", "sub_title", "pfm", "desc", "info", "url":
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
        case "sub_title":
            builder = builder.subTitle(subTitle: parsingData!)
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
