//
//  RegionListViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/10.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol RegionListViewModelInput {
    func select(region: Region)
}

protocol RegionListViewModelOutput {
    var regions : Observable<Array<Region>> { get }
    func selectedRegion() -> Observable<Region>
}

class RegionListViewModel {
    fileprivate let regionOptions = BehaviorSubject<Array<Region>>(value: Region.getAllRegion())
    fileprivate let selectedRegionOption = BehaviorSubject<Region>(value: Region.NO_REGION)
    
    fileprivate let repository : RegionRepository
    private let disposeBag  = DisposeBag()
    
    init(repository : RegionRepository) {
        self.repository = repository
        self.repository.observeRegion()
            .do(onNext: { region in
                self.selectedRegionOption.onNext(region)
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}

extension RegionListViewModel : RegionListViewModelInput {
    func select(region: Region) {
        Analytics.logEvent(
            TrackingEvent.REGION_CHANGED.rawValue,
            parameters: [
                TrackingEventParameter.SELECTED_REGION.rawValue: region.value().name
            ])
        repository.updateRegion(region: region)
    }
}

extension RegionListViewModel : RegionListViewModelOutput {
    var regions: Observable<Array<Region>> {
        return regionOptions.asObservable()
    }

    func selectedRegion() -> Observable<Region> {
        return repository.observeRegion()
    }
}
