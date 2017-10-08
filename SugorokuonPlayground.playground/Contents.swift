//: Playground - noun: a place where people can play

import UIKit
import Realm
import RealmSwift
import RxSwift

//playgroundで実行する際に必要なだけ
import PlaygroundSupport


URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)


enum ProviderType {
    case Radiko
    case Nhk
}


public class Station {
    
    init(id: String,
         name: String,
         asciiName: String,
         providerType: ProviderType,
         siteUrl: String,
         logoUrl: String,
         bannerUrl: String?,
         feed: String?,
         isOnAirSongsAvailable: Bool,
         logos: Array<StationLogo>) {
        self.id = id
        self.name = name
        self.asciiName = asciiName
        self.providerType = providerType
        self.siteUrl = siteUrl
        self.logoUrl = logoUrl
        self.bannerUrl = bannerUrl
        self.feed = feed
        self.isOnAirSongsAvailable = isOnAirSongsAvailable
        self.logos = logos
    }
    
    let id: String
    
    let name: String
    
    let asciiName: String
    
    let providerType: ProviderType
    
    let siteUrl: String
    
    let logoUrl: String
    
    let bannerUrl: String?
    
    let feed: String?
    
    let isOnAirSongsAvailable: Bool
    
    let logos: Array<StationLogo>
    
    class Builder {
        private var id: String = ""
        private var name: String = ""
        private var asciiName: String = ""
        private var providerType: ProviderType = .Radiko
        private var siteUrl: String = ""
        private var logoUrl: String = ""
        private var bannerUrl: String?
        private var feed: String?
        private var isOnAirSongsAvailable: Bool?
        private var logos: Array<StationLogo> = Array()
        
        func id(id: String) -> Builder {
            self.id = id
            return self
        }
        
        func name(name: String) -> Builder {
            // In some radio station, space is recognized as splitter
            // (e.g. "TBS radio" is parsed separately "TBS" and "radio"
            self.name += name
            return self
        }
        
        func asciiName(asciiName: String) -> Builder {
            self.asciiName = asciiName
            return self
        }
        
        func siteUrl(siteUrl: String) -> Builder {
            self.siteUrl = siteUrl
            return self
        }
        
        func logoUrl(logoUrl: String) -> Builder {
            self.logoUrl = logoUrl
            return self
        }
        
        func bannerUrl(bannerUrl: String) -> Builder {
            self.bannerUrl = bannerUrl
            return self
        }
        
        func feed(feed: String) -> Builder {
            self.feed = feed
            return self
        }
        
        func isOnAirSongsAvailable(isOnAirSongsAvailable: Bool) -> Builder {
            self.isOnAirSongsAvailable = isOnAirSongsAvailable
            return self
        }
        
        func addLogo(logo: StationLogo) -> Builder {
            self.logos.append(logo)
            return self
        }
        
        func build() -> Station {
            return Station(id: id,
                           name: name,
                           asciiName: asciiName,
                           providerType: providerType,
                           siteUrl: siteUrl,
                           logoUrl: logoUrl,
                           bannerUrl: bannerUrl,
                           feed: feed,
                           isOnAirSongsAvailable: isOnAirSongsAvailable ?? false,
                           logos: logos)
        }
    }
}


public class StationLogo {
    
    init(width: Int, height: Int, url: String) {
        self.width = width
        self.height = height
        self.url = url
    }
    
    let width: Int
    let height: Int
    let url: String
    
    class Builder {
        private var width: Int?
        private var height: Int?
        private var url: String?
        
        func width(width: Int) -> Builder {
            self.width = width
            return self
        }
        
        func height(height: Int) -> Builder {
            self.height = height
            return self
        }
        
        func url(url: String) -> Builder {
            self.url = url
            return self
        }
        
        func build() -> StationLogo {
            return StationLogo(
                width: width ?? 0,
                height: height ?? 0,
                url: url ?? "")
        }
    }
}




//@Root(strict = false)
//public static class TimeTableRoot {
//    
//    // 謎の値。
//    @Element
//    public int ttl;
//    
//    // 応答を返してきたサーバの時刻?
//    @Element
//    public long srvtime;
//    
//    @ElementList
//    public List<Station> stations;
//    
//    @Root(name = "station", strict = false)
//    public static class Station {
//        
//        @Attribute
//        public String id;
//        
//        @Element
//        public String name;
//        
//        @ElementList(name = "scd")
//        public List<TimeTable> timetables;
//        
//        @Root(name = "progs", strict = false)
//        public static class TimeTable {
//            
//            @Element(name = "date")
//            public Calendar date;
//            
//            @ElementList(inline = true)
//            public List<Program> programs;
//            
//            @Root(name = "prog", strict = false)
//            public static class Program {
//            
//            }
//        }
//    }
//}

class TimeTable {
    
    init (stationId : String, date : Date, programs : Array<Program>) {
        self.stationId = stationId
        self.date = date
        self.programs = programs
    }
    
    let stationId : String
    let date : Date
    let programs : Array<Program>
    
}


class Program {
    
    init(startTime : Date,
         endTime: Date,
         title : String,
         subTitle : String?,
         personality : String?,
         description : String?,
         info : String?,
         url : String?,
         metas : [String : String]?) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.subTitle = subTitle
        self.personality = personality
        self.description = description
        self.info = info
        self.url = url
        self.metas = metas
    }
    
    let startTime : Date
    let endTime: Date
    let title: String
    let subTitle: String?
    let personality: String?
    let description: String?
    let info: String?
    let url: String?
    let metas: [String : String]?

    class Builder {
        var startTime : Date?
        var endTime: Date?
        var title: String?
        var subTitle: String?
        var personality: String?
        var description: String?
        var info: String?
        var url: String?
        var metas: [String : String]? = [:]
        
        func start(from : Date) -> Builder {
            self.startTime = from
            return self
        }
        
        func end(at : Date) -> Builder {
            self.endTime = at
            return self
        }
        
        func title(title: String) -> Builder {
            self.title = title
            return self
        }
        
        func subTitle(subTitle : String) -> Builder {
            self.subTitle = subTitle
            return self
        }
        
        func personality(personality : String) -> Builder {
            self.personality = personality
            return self
        }
        
        func description(description : String) -> Builder {
            self.description = description
            return self
        }
        
        func info(info : String) -> Builder {
            self.info = info
            return self
        }
        
        func url(url : String) -> Builder {
            self.url = url
            return self
        }
        
        func addMeta(name : String, value : String) -> Builder {
            self.metas = [name : value]
            return self
        }
        
        func build() -> Program? {
            if let start = startTime, let end = endTime, let t = title {
                return Program(startTime: start,
                               endTime: end,
                               title: t,
                               subTitle: subTitle,
                               personality: personality,
                               description: description,
                               info: info,
                               url: url,
                               metas: metas)
            } else {
                return nil
            }
        }
    }
}

public class StationResponseParser: NSObject, XMLParserDelegate {
    
    private let disposeBag = DisposeBag()
    private var stations = Array<Station>()
    private var stationParser: StationParser?
    private let parsedResult: PublishSubject<Array<Station>> = PublishSubject<Array<Station>>()
    
    public func parsedStations() -> Observable<Array<Station>> {
        return parsedResult.asObserver()
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
        // メモ : 
        // ここで stationParser を local scope で持たせると、parser の処理の中で落ちる
        // parser.delegate = stationParser と参照を parser に張るも、
        // たぶん java とは違って、この scope を出た途端に stationParser のインスタンスは
        // 解放されるので、parser の中で解放済みインスタンスにアクセスして落ちるのではなかろうか
        
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

public class StationParser: NSObject, XMLParserDelegate {

    weak private var parent: XMLParserDelegate?

    private let disposeBag = DisposeBag()
    private let builder: Station.Builder = Station.Builder()
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
                builder.id(id: string)
                break
            case "name":
                builder.name(name: string)
                break
            case "ascii_name":
                builder.asciiName(asciiName: string)
                break
            case "href":
                builder.siteUrl(siteUrl: string)
                break
            case "logo_large":
                builder.logoUrl(logoUrl: string)
                break
            case "feed":
                builder.feed(feed: string)
                break
            case "banner":
                builder.bannerUrl(bannerUrl: string)
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
            builder.addLogo(logo: stationLogo)
        }
    }
    
}


class StationLogoParser: NSObject, XMLParserDelegate {
    
    weak private var parent: XMLParserDelegate?
    
    private let builder : StationLogo.Builder = StationLogo.Builder()
    
    private let parsedLogo : PublishSubject<StationLogo> = PublishSubject<StationLogo>()
    
    init(parent: XMLParserDelegate) {
        self.parent = parent
    }
    
    func setSize(width: Int, height: Int) {
        builder
            .width(width: width)
            .height(height: height)
    }
    
    func observeLogoParseComplete() -> Observable<StationLogo> {
        return parsedLogo.asObserver()
    }

    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        builder.url(url: string)
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

//<radiko>
//<ttl>1800</ttl>
//<srvtime>1504995471</srvtime>
//<stations>
//<station id="QRR">
//<name>文化放送</name>
//<scd>
//<progs>...</progs>
//<progs>...</progs>

class TodayTimeTableParser : NSObject, XMLParserDelegate {
    
    private var stationId : String?

    private let disposeBag = DisposeBag()
    private let parserdTimeTable = PublishSubject<TimeTable>()
    private var timeTableParser : TimeTableParser?
    
    public func observeTodayTimeTableParsed() -> Observable<TimeTable> {
        return parserdTimeTable.asObserver()
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
    
    private func onTimeTableParsed(event : RxSwift.Event<TimeTable>) -> Void {
        if let timeTable = event.element {
            
            let cal = Calendar(identifier: .gregorian)
            print(cal.component(.weekday, from: timeTable.date))
            print(cal.component(.weekdayOrdinal, from: timeTable.date))
            print(timeTable.stationId)
            
            parserdTimeTable.onNext(timeTable)
        }
    }
}

class WeeklyTimeTableParser : NSObject, XMLParserDelegate {
    // メモ : TodayTimeTableParser との違いは、emitするのが Array<TimeTable> になるため、
    // TimeTable が一つ終わっただけでは onNext してはいけない
    // </radiko> で emit するのがタイミングとしては適切そう
    
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
            timeTables.forEach({
                let testFormatter : DateFormatter = DateFormatter()
                testFormatter.dateFormat = "yyyy/MM/dd hh:mm"
                print("\(testFormatter.string(from: $0.date)) \($0.programs.count)")
            })
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

/**
 * Knows how to parse <progs>...</progs>
 *
 */

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

class ProgramParser: NSObject, XMLParserDelegate {

    weak private var parent: XMLParserDelegate?

    private let builder : Program.Builder = Program.Builder()
    
    private let parsedProgram : PublishSubject<Program> = PublishSubject<Program>()
    
    private var parsingElement : String? = nil
    
    init(parent: XMLParserDelegate, startTime: Date, endTime: Date) {
        self.parent = parent
        builder.start(from : startTime).end(at : endTime)
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
                builder.addMeta(name: name, value: value)
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
            builder.title(title: parsingData!)
            break
        case "sub_title":
            builder.subTitle(subTitle: parsingData!)
            break
        case "pfm":
            builder.personality(personality: parsingData!)
            break
        case "desc":
            builder.description(description: parsingData!)
            break
        case "info":
            builder.info(info: parsingData!)
            break
        case "url":
            builder.url(url: parsingData!)
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


//let url = URL(string: "http://radiko.jp/v2/station/list/JP13.xml")!
//var parser: XMLParser? = XMLParser(contentsOf: url)
////var parser: XMLParser? = XMLParser(data: xml.data(using: .utf8)!)
//
//var d = StationResponseParser()
//parser!.delegate = d
//
//print("parse start")
//parser?.parse()
//
////PlaygroundPage.current.needsIndefiniteExecution = true
//
//
//print("-----------------")
//
//d.getStations().forEach {
//    print(" - \($0.name)")
//}


// http://radiko.jp/v2/station/list/JP13.xml

//let testSingle: Single<String> =  Single<String>.just("aaa")
//
//let disposables = DisposeBag()
//testSingle.subscribe(
//    onSuccess: { str in
//        print("onSuccess : \(str)")
//},
//    onError: { e in
//        print("onError")
//}).addDisposableTo(disposables)



// ---- Realm の実験 ---- //
//// Dog model
//class Dog: Object {
//    dynamic var name = ""
//    dynamic var owner: Person? // Properties can be optional
//}
//
//// Person model
//class Person: Object {
//    dynamic var name = ""
//    dynamic var birthdate = Date(timeIntervalSince1970: 1)
//    let dogs = List<Dog>()
//}

// Personオブジェクトを作成する
//let author = Person()
//author.name = "David Foster Wallace"

// デフォルトRealmを取得する
//let realm = try! Realm()
//try! realm.write {
//    realm.deleteAll()
//}


//// Realmの取得はスレッドごとに１度だけ必要になります
//// トランザクションを開始して、オブジェクトをRealmに追加する
//try! realm.write {
//    realm.add(author)
//}
//
//// なぜ .self なのか? ⇛ http://nerd0geek1.hatenablog.com/entry/2016/01/31/200000
//let persons = realm.objects(Person.self)
//
//persons.forEach {
//    print($0.name)
//}


    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))

// http://radiko.jp/v2/api/program/station/today?station_id=QRR
//var programParser: XMLParser? = XMLParser(contentsOf: URL(string: "http://radiko.jp/v2/api/program/station/today?station_id=QRR")!)
//
//var pp = TodayTimeTableParser()
//programParser!.delegate = pp
//programParser?.parse()


//var weeklyParser : XMLParser? = XMLParser(contentsOf: URL(string: "http://radiko.jp/v2/api/program/station/weekly?station_id=TBS")!)
//
//var weeklyParserDelegate = WeeklyTimeTableParser()
//weeklyParser!.delegate = weeklyParserDelegate
//
//weeklyParser?.parse()
//



//let formatter: DateFormatter = DateFormatter()
//formatter.dateFormat = "yyyyMMdd"
//let testDate = formatter.date(from: "20170904")!
//
//let testFormatter : DateFormatter = DateFormatter()
//testFormatter.dateFormat = "yyyy/MM/dd hh:mm"
//print(testFormatter.string(from: testDate))

// Realmの取得はスレッドごとに１度だけ必要になります
// トランザクションを開始して、オブジェクトをRealmに追加する
//try! realm.write {
//    realm.add(author)
//}

// なぜ .self なのか? ⇛ http://nerd0geek1.hatenablog.com/entry/2016/01/31/200000
//let savedTimeTable : TimeTable = realm.objects(TimeTable.self)
//savedTimeTable.programs.forEach {
//    print($0.title)
//}


print("aaa")

let nowOnAirParser = XMLParser(contentsOf: URL(string: "http://radiko.jp/v3/feed/pc/noa/TBS.xml")!)!
let res = nowOnAirParser.parse()



