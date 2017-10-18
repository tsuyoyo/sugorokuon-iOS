//
//  OnAirSongViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/01.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

typealias OnAirSongsList = (station: Station, songs: Array<OnAirSong>)

protocol OnAirSongPagerViewModelOutput {
    var fetchedOnAirSongs: Observable<Array<OnAirSongsList>> { get }
}

protocol OnAirSongPagerViewModelInput {
    func fetchOnAirSongs(region id: String)
}

class OnAirSongPagerViewModel {
    fileprivate let disposeBag = DisposeBag()
    fileprivate let onAirSongs = BehaviorSubject<Array<OnAirSongsList>>(value: [])
    fileprivate let stationApi: StationApi
    fileprivate let feedApi: FeedApi
    
    init(stationApi: StationApi, feedApi: FeedApi) {
        self.stationApi = stationApi
        self.feedApi = feedApi
    }
}

extension OnAirSongPagerViewModel : OnAirSongPagerViewModelInput {

    func fetchOnAirSongs(region id: String) {
        var fetchedData : Array<OnAirSongsList> = []
                
        stationApi.fetchStations(region: id)
            .subscribeOn(OperationQueueScheduler(operationQueue: OperationQueue()))
            .observeOn(OperationQueueScheduler(operationQueue: OperationQueue()))
            .flatMap { stations -> Observable<Station> in
                return Observable<Station>.from(stations)
            }
            .map { station -> OnAirSongsList in
                return OnAirSongsList(station: station, songs: [])
            }
            .flatMap { onAirSongs -> Observable<OnAirSongsList> in
                return self.feedApi
                    .fetchNowOnAirSongs(station: onAirSongs.station.id)
                    .map { songs -> OnAirSongsList in
                        return OnAirSongsList(station: onAirSongs.station, songs: songs)
                    }
            }
            .filter { onAirSongs -> Bool in
                return !onAirSongs.songs.isEmpty
            }
            .subscribe(
                onNext: { onAirSongs in
                    fetchedData.append(onAirSongs)
                    self.onAirSongs.onNext(fetchedData)
                },
                onCompleted: {
                    // Not called onCopleted... What's wrong?
                    self.onAirSongs.onNext(fetchedData)
                })
            .addDisposableTo(disposeBag)
    }
}

extension OnAirSongPagerViewModel : OnAirSongPagerViewModelOutput {
    var fetchedOnAirSongs: Observable<Array<OnAirSongsList>> {
        return onAirSongs.asObservable()
    }
}
