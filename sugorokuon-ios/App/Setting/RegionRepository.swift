//
//  RegionRepository.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/11.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

class RegionObject: Object {
    dynamic var name : String = ""
}

class RegionRepository {
    
    static private var sRepository : RegionRepository?
    
    static func get() -> RegionRepository {
        if sRepository == nil {
            sRepository = RegionRepository(realm: try! Realm())
        }
        return sRepository!
    }
    
    private let realm : Realm
    private var region : BehaviorSubject<Region>!
    
    init(realm : Realm) {
        self.realm = realm
        self.region = BehaviorSubject<Region>(value:
            getSavedRegion(realmResult: realm.objects(RegionObject.self)))
    }
    
    func observeRegion() -> Observable<Region> {
        return region.asObservable()
    }
    
    func updateRegion(region: Region) {
        let regionObj = RegionObject()
        regionObj.name = region.rawValue
        try! realm.write {
            realm.add(regionObj)
            self.region.onNext(region)
        }
    }
    
    private func getSavedRegion(realmResult : Results<RegionObject>) -> Region {
        if let savedObj = realmResult.first {
            if let r = Region(rawValue: savedObj.name) {
                return r
            } else {
                return Region.NO_REGION
            }
        } else {
            return Region.NO_REGION
        }
    }
    
}

