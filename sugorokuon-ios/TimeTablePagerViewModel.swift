//
//  TimeTablePagerViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/19.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

protocol TimeTablePagerViewModelInput {
    func setAreaAndDate(region id: String, date: Date) -> Void
}

protocol TimeTablePagerViewModelOutput {

    var selectedDate : Observable<Date> { get }
    
    var fetchedTimeTable : Observable<Array<TimeTable>> { get }
    
    var fetchedStations : Observable<Array<Station>> { get }
    
    var fetchErrorSignal : Observable<String> { get }
}

class TimeTablePagerViewModel {

    fileprivate var stationParser : XMLParser!
    fileprivate var stationResponseParser : StationResponseParser!
    
    fileprivate var oneDayParser : XMLParser!
    fileprivate var oneDayResponseParser : OneDayTimeTableParser!
    
    fileprivate let urlManager : UrlManager

    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let date = PublishSubject<Date>()
    fileprivate let timeTables = PublishSubject<Array<TimeTable>>()
    fileprivate let stations = PublishSubject<Array<Station>>()
    fileprivate let fetchError = PublishSubject<String>()
    
    init(urlManager: UrlManager) {
        self.stationResponseParser = StationResponseParser()

        self.oneDayResponseParser = OneDayTimeTableParser()
        
        self.urlManager = urlManager
    }
}

extension TimeTablePagerViewModel : TimeTablePagerViewModelInput {
    
    func setAreaAndDate(region id: String, date: Date) {
        fetchStations(region: id)
        fetchTimeTable(region: id, date: date)
        self.date.onNext(date)
    }
    
    private func fetchStations(region id : String) {
        let stationListUrl = URL(string: urlManager.stationList(region: id))
        stationParser = XMLParser(contentsOf: stationListUrl!)
        stationResponseParser = StationResponseParser()
        stationParser?.delegate = stationResponseParser
        
        stationResponseParser.parsedStations()
            .subscribe(onNext: { stations in
                self.stations.onNext(stations)
            },
            onError: { error in
                self.fetchError.onNext(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)

        self.stationParser?.parse()
    }
    
    private func fetchTimeTable(region id : String, date : Date) {
        let calendar = Calendar(identifier: .gregorian)
        let timeTableUrl = URL(string: urlManager.timeTable(
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date),
            day: calendar.component(.day, from: date),
            region: id))
        
        oneDayParser = XMLParser(contentsOf: timeTableUrl!)
        oneDayResponseParser = OneDayTimeTableParser()
        oneDayParser?.delegate = oneDayResponseParser

        oneDayResponseParser.observeTodayTimeTableParsed()
            .subscribe(onNext: { timeTables in
                self.timeTables.onNext(timeTables)
            },
            onError: { error in
                self.fetchError.onNext(error.localizedDescription)
            })
            .addDisposableTo(disposeBag)
        
        oneDayParser?.parse()
    }
}

extension TimeTablePagerViewModel : TimeTablePagerViewModelOutput {
    var selectedDate: Observable<Date> {
        return self.date.asObservable()
    }
    
    var fetchedStations: Observable<Array<Station>> {
        return self.stations.asObserver()
    }

    var fetchedTimeTable: Observable<Array<TimeTable>> {
        return self.timeTables.asObserver()
    }
    
    var fetchErrorSignal: Observable<String> {
        return self.fetchError.asObserver()
    }
}
