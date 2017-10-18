//
//  FeedApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxCocoa
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
    func fetchNowOnAirSongs(station id : String) -> Observable<Array<OnAirSong>> {
        let url = URL(string: self.urlManager.nowOnAir(station: id))!
        return URLSession.shared
            .rx
            .response(request: URLRequest(url: url))
            .flatMap({ (response, data) -> Observable<Array<OnAirSong>> in
                if response.statusCode == 200 {
                    let parser = XMLParser(data: data)
                    let delegate = NowOnAirParser()
                    parser.delegate = delegate
                    
                    let observable = delegate.observeNowOnAirParsed()
                    parser.parse()
                    return observable
                } else {
                    return Observable.just([])
                }
            })
    }
}
