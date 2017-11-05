//
//  SearchViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/29.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

typealias SearchResult = (program : Program, station: Station)

protocol SearchViewModelInput {
    func search(word: String, region: Region)
    func clearResult()
}

protocol SearchViewModelOutput {
    func observeResults() -> Observable<Array<SearchResult>>
    func observeIsSearching() -> Observable<Bool>
    func observeSearchError() -> Observable<String>
}

class SearchViewModel {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let searchApi : SearchApi
    fileprivate let stationApi : StationApi
    
    fileprivate let searchResult = BehaviorSubject<Array<SearchResult>>(value: [])
    fileprivate let searchError = PublishSubject<String>()
    fileprivate let isSearching = BehaviorSubject<Bool>(value: false)
    
    init(searchApi: SearchApi, stationApi: StationApi) {
        self.searchApi = searchApi
        self.stationApi = stationApi
    }
}

extension SearchViewModel : SearchViewModelInput {
    func search(word: String, region: Region) {
        isSearching.onNext(true)
        Observable.zip(
            stationApi.fetchStations(region: region.value().id),
            searchApi.search(word: word, region: region.value().id)) {
                (stations, foundPrograms) -> Array<SearchResult> in
                return self.mapToSearchResults(
                    stations: stations, foundPrograms: foundPrograms)
            }
            .do(onNext: { results in
                    self.isSearching.onNext(false)
                    self.searchResult.onNext(results)
                },
                onError: { e in
                    self.isSearching.onNext(false)
                }
            )
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    private func mapToSearchResults(
        stations: Array<Station>,
        foundPrograms: Array<SearchResultProgram>) -> Array<SearchResult> {
        
        var results = Array<SearchResult>()
        
        foundPrograms.forEach({ (program) in
            
            var builder = Program.Builder()
                .start(from: program.start)
                .end(at: program.end)
                .title(title: program.title)
                .personality(personality: program.personality)
            
            if let description = program.description {
                builder = builder.description(description: description)
            }
            if let info = program.info {
                builder = builder.info(info: info)
            }
            if let url = program.url {
                builder = builder.url(url: url)
            }
            if let image = program.image {
                builder = builder.image(image: image)
            }

            let station = stations.first(where: { s -> Bool in
                s.id == program.stationId }
            )
            if let s = station {
                results.append(SearchResult(
                    program: builder.build()!,
                    station: s
                ))
            }
        })
        
        // Sort results by latest order.
        results.sort { (r, l) -> Bool in
            return r.program.startTime > l.program.startTime
        }
        
        return results
    }
    
    func clearResult() {
        searchResult.onNext([])
    }
}

extension SearchViewModel : SearchViewModelOutput {
    
    func observeIsSearching() -> Observable<Bool> {
        return isSearching.asObservable()
    }
    
    func observeResults() -> Observable<Array<SearchResult>> {
        return searchResult.asObservable()
    }
    
    func observeSearchError() -> Observable<String> {
        return searchError.asObservable()
    }
}
