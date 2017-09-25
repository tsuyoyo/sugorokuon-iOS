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
    func setArea(id: String) -> Void
}

protocol TimeTablePagerViewModelOutput {
    var fetchedStations : Observable<Array<Station>> { get }
    var fetchedStationError : Observable<String> { get }
}

class TimeTablePagerViewModel {

    fileprivate var stationParser : XMLParser?
    fileprivate let stationResponseParser : StationResponseParser
    fileprivate let urlManager : UrlManager

    fileprivate let disposeBag = DisposeBag()
    fileprivate let stations = PublishSubject<Array<Station>>()
    fileprivate let fetchStationError = PublishSubject<String>()
    
    init(urlManager: UrlManager) {
        self.stationResponseParser = StationResponseParser()
        self.urlManager = urlManager
    }
}

extension TimeTablePagerViewModel : TimeTablePagerViewModelInput {

    func setArea(id : String) -> Void {
        let url = URL(string: urlManager.stationList(region: id))
        stationParser = XMLParser(contentsOf: url!)
        stationParser?.delegate = stationResponseParser
        
        stationResponseParser
            .parsedStations()
            .do(onNext: { stations in
                    self.stations.onNext(stations)
                },
                onError: { error in
                    self.fetchStationError.onNext(error.localizedDescription)
                }
            )
            .subscribe()
            .addDisposableTo(disposeBag)
        
        self.stationParser?.parse()
    }
}

extension TimeTablePagerViewModel : TimeTablePagerViewModelOutput {
    
    var fetchedStationError: Observable<String> {
        return self.fetchStationError.asObserver()
    }

    var fetchedStations: Observable<Array<Station>> {
        return self.stations.asObserver()
    }
}
