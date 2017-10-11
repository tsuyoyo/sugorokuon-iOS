//
//  FeedApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

class FeedApi {
    
    enum Error : Swift.Error {
        case NowOnAirNotFound
    }
    
    let urlManager: UrlManager
    private var disposeBag = DisposeBag()
    
    init(urlManager : UrlManager) {
        self.urlManager = urlManager
    }
    
    /**
     * When NowOnAir songs are not available for the station,
     * it will emit [] (empty array).
     *
     */
    func fetchNowOnAirSongs(station id : String) -> Single<Array<OnAirSong>> {
        return Single<Array<OnAirSong>>.create(subscribe: { (observer) -> Disposable in
            let url = URL(string: self.urlManager.nowOnAir(station: id))!
            let parser = XMLParser(contentsOf: url)!
            let delegate = NowOnAirParser()

            parser.delegate = delegate
            if parser.parse() {
                delegate
                    .observeNowOnAirParsed()
                    .do(onNext: { items in
                        observer(.success(items))
                    })
                    .subscribe()
                    .addDisposableTo(self.disposeBag)
            } else {
                observer(.success([]))
            }
            return Disposables.create()
        })
    }
}
