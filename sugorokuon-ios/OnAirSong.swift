//
//  OnAirSong.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class OnAirSong {

    let title: String
    let artist: String
    let onAirTime: Date
    let image: String?
    let amazon: String?
    let iTunes: String?
    let recochoku: String?
    
    init(title: String,
         artist: String,
         onAirTime: Date,
         image: String?,
         amazon: String?,
         iTunes: String?,
         recochoku: String?) {
        self.title = title
        self.artist = artist
        self.onAirTime = onAirTime
        self.image = image
        self.amazon = amazon
        self.iTunes = iTunes
        self.recochoku = recochoku
    }
    
    class Builder {
        
        enum BuildingError: Error {
            case InsufficientValues
        }
        
        var title: String?
        var artist: String?
        var onAirTime: Date?
        var image: String?
        var amazon: String?
        var iTunes: String?
        var recochoku: String?
        
        func title(title: String) -> Builder {
            self.title = title
            return self
        }
        
        func artist(artist: String) -> Builder {
            self.artist = artist
            return self
        }
        
        func onAirTime(onAirTime: Date) -> Builder {
            self.onAirTime = onAirTime
            return self
        }
        
        func image(image: String) -> Builder {
            self.image = image
            return self
        }
        
        func amazon(amazon: String) -> Builder {
            self.amazon = amazon
            return self
        }
        
        func iTunes(iTunes: String) -> Builder {
            self.iTunes = iTunes
            return self
        }
        
        func recochoku(recochoku: String) -> Builder {
            self.recochoku = recochoku
            return self
        }
        
        func build() throws -> OnAirSong {
            guard let _ = title, let _ = artist, let _ = onAirTime else {
                throw BuildingError.InsufficientValues
            }            
            return OnAirSong(
                title: title!,
                artist: artist!,
                onAirTime: onAirTime!,
                image: image,
                amazon: amazon,
                iTunes: iTunes,
                recochoku: recochoku)
        }
        
    }
    
    
    
}
