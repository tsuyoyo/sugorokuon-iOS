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

    func setDate(date: Date) -> Void
    
    func fetchNextDay() -> Void
    
    func fetchPreviousDay() -> Void
    
    func fetchToday() -> Void
    
    func closeIntroduction() -> Void
}

protocol TimeTablePagerViewModelOutput {

    var selectedDate : Observable<Date> { get }
    
    var fetchedTimeTable : Observable<Array<TimeTable>> { get }
    
    var fetchedStations : Observable<Array<Station>> { get }
    
    var fetchErrorSignal : Observable<String> { get }
    
    var isFetching : Observable<Bool> { get }
    
    var showIntroduction : Observable<Bool> { get }
    
    var isNextDayAvailable : Observable<Bool> { get }
    
    var isPreviousDayAvailable : Observable<Bool> { get }
}

class TimeTablePagerViewModel {
    
    fileprivate let stationApi : StationApi
    fileprivate let timeTableApi : TimeTableApi
    fileprivate let radikoDateUtil : RadikoDateUtil

    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let regionRepository : RegionRepository
    fileprivate var region : String!
    
    fileprivate let date : BehaviorSubject<Date>
    fileprivate let timeTables = PublishSubject<Array<TimeTable>>()
    fileprivate let stations = PublishSubject<Array<Station>>()
    fileprivate let fetchError = PublishSubject<String>()
    fileprivate let fetching = BehaviorSubject<Bool>(value: false)
    fileprivate let signalToShowIntruduction = BehaviorSubject<Bool>(value: false)
    fileprivate let nextDayAvailable = BehaviorSubject<Bool>(value: false)
    fileprivate let previousDayAvailable = BehaviorSubject<Bool>(value: false)
    
    init(stationApi: StationApi,
         timeTableApi: TimeTableApi,
         regionRepository: RegionRepository,
         radikoDateUtil : RadikoDateUtil) {
        self.stationApi = stationApi
        self.timeTableApi = timeTableApi
        self.regionRepository = regionRepository
        self.radikoDateUtil = radikoDateUtil
        self.date = BehaviorSubject<Date>(value: radikoDateUtil.getToday())
    }
    
    func setup() {
        Observable
            .combineLatest(
                self.regionRepository.observeRegion(),
                self.date
            )
            .subscribe({ event in
                if let region : Region = event.element?.0,
                    let date : Date = event.element?.1 {
                    if region == Region.NO_REGION {
                        self.signalToShowIntruduction.onNext(true)
                    } else {
                        self.setAreaAndDate(
                            region: region.value().id,
                            date: date
                        )
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        date.subscribe(onNext: { d in
            let now = self.radikoDateUtil.getToday()
            let rangeTail = now.addingTimeInterval(60 * 60 * 24 * 7)
            let rangeBegin = now.addingTimeInterval((-1) * 60 * 60 * 24 * 7)
            
            self.nextDayAvailable.onNext(d < rangeTail)
            self.previousDayAvailable.onNext(d > rangeBegin)
            
        }).addDisposableTo(disposeBag)
    }
    
    private func setAreaAndDate(region id: String, date: Date) {
        region = id
        fetching.onNext(true)
        Observable
            .zip(stationApi.fetchStations(region: region),
                 timeTableApi.fetchTimeTable(region: region, date: date)) {
                    (stations, timeTables) in
                    self.stations.onNext(stations)
                    self.timeTables.onNext(timeTables)
                    self.fetching.onNext(false)
            }
            .do(onError: { error in
                self.fetching.onNext(false)
                self.fetchError.onNext(error.localizedDescription)
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
}

extension TimeTablePagerViewModel : TimeTablePagerViewModelInput {
    
    func setDate(date: Date) {
        self.date.onNext(date)
    }
    
    func fetchToday() {
        setDate(date: radikoDateUtil.getToday())
    }
    
    func fetchNextDay() {
        fetchTimeTable(timeInterval: 60 * 60 * 24)
    }
    
    func fetchPreviousDay() {
        fetchTimeTable(timeInterval: (-1) * 60 * 60 * 24)
    }
    
    func closeIntroduction() {
        signalToShowIntruduction.onNext(false)
    }
    
    private func fetchTimeTable(timeInterval sinceToday: Double) {
        var currentDate : Date
        do {
            try currentDate = date.value()
        } catch {
            return
        }
        date.onNext(
            Date(
                timeInterval: sinceToday,
                since: currentDate
            )
        )
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
    
    var showIntroduction: Observable<Bool> {
        return self.signalToShowIntruduction.asObservable()
    }
    
    var isNextDayAvailable: Observable<Bool> {
        return self.nextDayAvailable.asObservable()
    }
    
    var isPreviousDayAvailable: Observable<Bool> {
        return self.previousDayAvailable.asObservable()
    }
}
