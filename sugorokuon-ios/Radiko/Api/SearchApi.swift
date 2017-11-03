//
//  SearchApi.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Crashlytics


class SearchApi {
    
    let urlManager : UrlManager
    private let disposeBag = DisposeBag()
    
    init (urlManager : UrlManager) {
        self.urlManager = urlManager
    }
    
    func search(word: String, region: String) -> Observable<Array<SearchResultProgram>> {
        let url = URL(string: urlManager.search(word: word, region: region))!
        return URLSession.shared
            .rx
            .response(request: URLRequest(url: url))
            .flatMap {(response, data) -> Observable<Array<SearchResultProgram>> in
                if response.statusCode == 200 {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(
                            with: data,
                            options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        if let root = jsonData as? NSDictionary {
                            return Observable.just(self.parse(responseJson: root))
                        } else {
                            Crashlytics.sharedInstance().recordCustomExceptionName(
                                "SearchFailed",
                                reason: "Response root was not NSDictionary",
                                frameArray: [])
                        }
                    } catch {
                        Crashlytics.sharedInstance().recordCustomExceptionName(
                            "SearchFailed",
                            reason: "Failed json serialization",
                            frameArray: [])
                    }
                }
                return Observable.just([])
            }
    }
    
    private func parse(responseJson : NSDictionary) -> Array<SearchResultProgram> {
        var searchResults = Array<SearchResultProgram>()
        if let dataArray = responseJson["data"] as? NSArray {
            for data in dataArray {
                let d = data as! NSDictionary
                searchResults.append(SearchResultProgram(
                    title: d["title"] as! String,
                    personality: d["performer"] as! String,
                    stationId: d["station_id"] as! String,
                    image: d["img"] as? String,
                    start: parseDate(from: d["start_time"] as! String),
                    end: parseDate(from: d["end_time"] as! String),
                    url: d["program_url"] as? String,
                    description: d["description"] as? String,
                    info: d["info"] as? String)
                )
            }
        }
        return searchResults
    }
    
    private func parseDate(from: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: from)!
    }
}
