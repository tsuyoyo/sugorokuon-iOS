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
    
    public func timeTable(date: Date, region: String) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let date = "\(String(format: "%04d", year))\(String(format: "%02d", month))\(String(format: "%02d", day))"
        
        return "\(Domain)/v3/program/date/\(date)/\(region).xml"
    }
    
    public func nowOnAir(station id: String) -> String {
        return "\(Domain)/v3/feed/pc/noa/\(id).xml"
    }
    
    public func search(word : String, region : String) -> String {
        let encodedWord = word.addingPercentEncoding(
            withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let uid : String = ProcessInfo.processInfo.globallyUniqueString
        let replacedUid = uid.replacingOccurrences(of: "-", with: "")
            .substring(to: uid.index(uid.startIndex, offsetBy: 32))
            .lowercased()
        
        return "\(Domain)/v3/api/program/search?"
            + "key=\(encodedWord ?? "")"
            + "&filter="
            + "&start_day="
            + "&end_day="
            + "&area_id=\(region)"
            + "&region_id="
            + "&cul_area_id=\(region)"
            + "&page_idx="
            + "&uid=\(replacedUid)"
            + "&row_limit=12"
            + "&app_id=pc"
            + "&action_id=0"
    }
    
}
