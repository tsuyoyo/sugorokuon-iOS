//
//  IntroductionViewModel.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/18.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import RxSwift

protocol IntroductionViewModelInput {
    func select(region: Region)
}

protocol IntroductionViewModelOutput {
    var regions : Observable<Array<Region>> { get }
    var closeButtonAvailability: Observable<Bool>{ get }
}

class IntroductionViewModel {
    
    fileprivate let regionRepository : RegionRepository
    
    init(regionRepository: RegionRepository) {
        self.regionRepository = regionRepository
    }
}

extension IntroductionViewModel : IntroductionViewModelInput {
    func select(region: Region) {
        regionRepository.updateRegion(region: region)
    }
}

extension IntroductionViewModel : IntroductionViewModelOutput {
    var regions: Observable<Array<Region>> {
        return Observable.just(Region.getAllRegion())
    }
    
    var closeButtonAvailability: Observable<Bool> {
        return regionRepository
            .observeRegion()
            .map({ r -> Bool in return r != Region.NO_REGION})
    }
}
