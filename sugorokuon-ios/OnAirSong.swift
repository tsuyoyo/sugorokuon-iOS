//
//  OnAirSong.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class OnAirSong {
    
    init(stationId: String,
         artist: String,
         title: String,
         date: NSCalendar,
         imageUrl: String,
         amazon: String?,
         recochoku: String?
        ) {
        self.stationId = stationId
        self.artist = artist
        self.title = title
        self.date = date
        self.imageUrl = imageUrl
        self.amazon = amazon
        self.recochoku = recochoku
    }
    
    let stationId: String
    
    let artist: String
    
    let title: String
    
    let date: NSCalendar
    
    let imageUrl: String
    
    let amazon: String?
    
    let recochoku: String?
    
}
