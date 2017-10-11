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
    
    func fetchNextDay() -> Void
    
    func fetchPreviousDay() -> Void
}

protocol TimeTablePagerViewModelOutput {

    var selectedDate : Observable<Date> { get }
    
    var fetchedTimeTable : Observable<Array<TimeTable>> { get }
    
    var fetchedStations : Observable<Array<Station>> { get }
    
    var fetchErrorSignal : Observable<String> { get }
    
    var isFetching : Observable<Bool> { get }
}

class TimeTablePagerViewModel {
    
    fileprivate let stationApi : StationApi
    fileprivate let timeTableApi : TimeTableApi

    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var region : String!
    
    fileprivate let date : BehaviorSubject<Date>
    fileprivate let timeTables = PublishSubject<Array<TimeTable>>()
    fileprivate let stations = PublishSubject<Array<Station>>()
    fileprivate let fetchError = PublishSubject<String>()
    fileprivate let fetching = BehaviorSubject<Bool>(value: false)
    
    init(stationApi: StationApi, timeTableApi: TimeTableApi) {
        self.stationApi = stationApi
        self.timeTableApi = timeTableApi
        self.date = BehaviorSubject<Date>(value: Date())
    }
}

extension TimeTablePagerViewModel : TimeTablePagerViewModelInput {
    
    func setAreaAndDate(region id: String, date: Date) {
        region = id
        fetching.onNext(true)
        Observable
            .zip(stationApi.fetchStations(region: region),
                 timeTableApi.fetchTimeTable(region: region, date: date)) {
                    (stations, timeTables) in
                    self.stations.onNext(stations)
                    self.timeTables.onNext(timeTables)
                    self.fetching.onNext(false)
                    self.date.onNext(date)
            }
            .do(onError: { error in
                self.fetching.onNext(false)
                self.fetchError.onNext(error.localizedDescription)
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    func fetchNextDay() {
        fetchTimeTable(timeInterval: 60 * 60 * 24)
    }
    
    func fetchPreviousDay() {
        fetchTimeTable(timeInterval: (-1) * 60 * 60 * 24)
    }
    
    private func fetchTimeTable(timeInterval sinceToday: Double) {
        var currentDate : Date
        do {
            try currentDate = date.value()
        } catch {
            return
        }
        self.fetching.onNext(true)
        let nextDay = Date(timeInterval: sinceToday, since: currentDate)
        timeTableApi.fetchTimeTable(region: region!, date: nextDay)
            .do(
                onNext: { timeTables in
                    self.fetching.onNext(false)
                    self.timeTables.onNext(timeTables)
                    self.date.onNext(nextDay)
            },
                onError: { error in
                    self.fetching.onNext(false)
                    self.fetchError.onNext(error.localizedDescription)
            }
            )
            .subscribe()
            .addDisposableTo(disposeBag)
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
    
    var isFetching: Observable<Bool> {
        return self.fetching.asObservable()
    }
}
