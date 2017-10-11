//
//  Feed.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class Feed {
 
    init(onAirSongs: Array<OnAirSong>) {
        self.onAirSongs = onAirSongs

    }
    
    let onAirSongs: Array<OnAirSong>
    
}
