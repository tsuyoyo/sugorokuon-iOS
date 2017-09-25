//
//  TimeTableViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/21.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

protocol TimeTableViewModelInput {
    func setTimeTable(station id: String, day: Week) -> Void
}

protocol TimeTableViewModelOutput {
    var fetchedPrograms : Observable<Array<Program>> { get }
    var fetchProgramsError : Observable<String> { get }
}

class TimeTableViewModel {
    
    fileprivate let timeTableRepository : TimeTableRepository
    fileprivate let urlManager : UrlManager
    
    fileprivate var xmlParser : XMLParser?
    fileprivate let weeklyTimeTableParser : WeeklyTimeTableParser
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let programs = PublishSubject<Array<Program>>()
    fileprivate let programsError = PublishSubject<String>()
    
    init(repository: TimeTableRepository, urlManager: UrlManager) {
        self.timeTableRepository = repository
        self.urlManager = urlManager
        self.weeklyTimeTableParser = WeeklyTimeTableParser()
    }
}

extension TimeTableViewModel : TimeTableViewModelInput {
    
    func setTimeTable(station id: String, day: Week) {
        timeTableRepository
            .load(station: id, day: day)
            .catchError { e -> Single<TimeTable> in
                if (e as! TimeTableRepository.Error) == .noElements {
                    return self.fetchWeeklyTimeTable(station: id, day: day)
                } else {
                    return Single.error(e)
                }
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .do (onNext: { timeTable -> Void in
                self.programs.onNext(timeTable.programs)
            })
            .subscribe(onError: { e -> Void in
                self.programsError.onNext(e.localizedDescription)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func fetchWeeklyTimeTable(station id: String, day: Week) -> Single<TimeTable> {
        
        return Single<TimeTable>.create(subscribe: { (observer) -> Disposable in
            let url = URL(string: self.urlManager.weeklyTimeTable(station: id))
            self.xmlParser = XMLParser(contentsOf: url!)
            self.xmlParser?.delegate = self.weeklyTimeTableParser
            
            self.weeklyTimeTableParser
                .observeWeeklyTimeTableParsed()
                .do(onNext: { timeTables -> Void in
                    self.timeTableRepository.store(station: id,timeTables: timeTables)
                })
                .flatMap { _ -> Single<TimeTable> in
                    self.timeTableRepository.load(station: id, day: day)
                }
                .do(onNext: { timeTable -> Void in
                    observer(.success(timeTable))
                })
                .subscribe(onError: { error -> Void in
                    observer(.error(error))
                })
                .addDisposableTo(self.disposeBag)

            self.xmlParser?.parse()
            return Disposables.create()
        })
    }
}

extension TimeTableViewModel : TimeTableViewModelOutput {
    
    var fetchedPrograms: Observable<Array<Program>> {
        return programs.asObserver()
    }

    var fetchProgramsError: Observable<String> {
        return programsError.asObserver()
    }
}
