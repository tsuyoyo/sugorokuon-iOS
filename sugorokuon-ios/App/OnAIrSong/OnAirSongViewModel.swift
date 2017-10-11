//
//  OnAirSongViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/03.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

protocol OnAirSongViewModelInput {
    func fetchOnAirSongs()
}

protocol OnAirSongViewModelOutput {
    var onAirSongs : Observable<Array<OnAirSong>> { get }
    var isFetching : Observable<Bool> { get }
}

class OnAirSongViewModel {
    fileprivate let songs = BehaviorSubject<Array<OnAirSong>>(value: [])
    fileprivate let fetching = BehaviorSubject<Bool>(value: false)
    
    fileprivate let onAirSongsList : OnAirSongsList
    fileprivate let feedApi : FeedApi
    fileprivate let disposeBag = DisposeBag()
    
    init(onAirSongs : OnAirSongsList, feedApi : FeedApi) {
        self.onAirSongsList = onAirSongs
        self.feedApi = feedApi
        sortAndEmit(onAirSongs: onAirSongs.songs)
    }
    
    fileprivate func sortAndEmit(onAirSongs : Array<OnAirSong>) {
        var songList = onAirSongs
        songList.sort(by: { (a, b) -> Bool in
            return a.onAirTime > b.onAirTime
        })
        songs.onNext(songList)
    }
}

extension OnAirSongViewModel : OnAirSongViewModelOutput {
    var isFetching: Observable<Bool> {
        return fetching.asObservable()
    }
    
    var onAirSongs: Observable<Array<OnAirSong>> {
        return songs.asObservable()
    }
}

extension OnAirSongViewModel : OnAirSongViewModelInput {
    func fetchOnAirSongs() {
        fetching.onNext(true)
        feedApi
            .fetchNowOnAirSongs(station: onAirSongsList.station.id)
            .subscribeOn(OperationQueueScheduler(operationQueue: OperationQueue()))
            .do(
                onNext: { songs in
                    self.sortAndEmit(onAirSongs: songs)
                    self.fetching.onNext(false)
                },
                onError: { error in
                    // Do nothing
                    self.fetching.onNext(false)
                }
            )
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}

