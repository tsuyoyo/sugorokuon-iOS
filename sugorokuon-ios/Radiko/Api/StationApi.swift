//
//  StationApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

class StationApi {
    
    private let urlManager : UrlManager
    
    init (urlManager: UrlManager) {
        self.urlManager = urlManager
    }
    
    func fetchStations(region id : String) -> Observable<Array<Station>> {
        let url = URL(string: urlManager.stationList(region: id))
        let parser = XMLParser(contentsOf: url!)
        let delegate = StationResponseParser(urlManager: urlManager)
        parser!.delegate = delegate
        
        let stationObserver = delegate.parsedStations()
        parser?.parse()
        return stationObserver
    }    
}
