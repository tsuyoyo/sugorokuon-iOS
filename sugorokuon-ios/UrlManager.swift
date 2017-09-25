//
//  UrlManager.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/23.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class UrlManager {
    
    private let Domain = "https://radiko.jp"
    
    public func stationList(region id : String) -> String {
        return "\(Domain)/v2/station/list/\(id).xml"
    }
    
    public func weeklyTimeTable(station id : String) -> String {
        return "\(Domain)/v2/api/program/station/weekly?station_id=\(id)"
    }
    
}
