//
//  StationApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class StationApi {
    
    private let urlManager : UrlManager
    
    init (urlManager: UrlManager) {
        self.urlManager = urlManager
    }
    
    func fetchStations(region id : String) -> Observable<Array<Station>> {
        let url = URL(string: urlManager.stationList(region: id))!
        return URLSession.shared
            .rx
            .response(request: URLRequest(url: url))
            .flatMap { (_, data) -> Observable<Array<Station>> in
                let delegate = StationResponseParser(urlManager: self.urlManager)
                let parser = XMLParser(data: data)
                parser.delegate = delegate
                
                let stationObserver = delegate.parsedStations()
                parser.parse()
                return stationObserver
            }
    }

}
