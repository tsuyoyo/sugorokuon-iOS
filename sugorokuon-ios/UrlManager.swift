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
    
    public func timeTable(year: Int, month: Int, day: Int, region: String) -> String {
        let date = "\(String(format: "%04d", year))\(String(format: "%02d", month))\(String(format: "%02d", day))"
        
        return "\(Domain)/v3/program/date/\(date)/\(region).xml"
    }
    
}
