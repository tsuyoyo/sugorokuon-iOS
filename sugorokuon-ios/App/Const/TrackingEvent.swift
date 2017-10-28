//
//  TrackingEvents.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/26.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

enum TrackingEvent : String {
    case PROGRAM_TAB_TAPPED = "program_tab_tapped"
    case ON_AIR_SONGS_TAB_TAPPED = "on_air_songs_tab_tapped"
    case SETTINGS_TAB_TAPPED = "settings_tab_tapped"
    case PROGRAM_ITEM_TAPPED = "program_item_tapped"
    case ON_AIR_SONG_ITEM_TAPPED = "on_air_song_item_tapped"
    case REGION_CHANGED = "region_changed"
    case NEXT_DAY_TAPPED = "next_day_tapped"
    case PREVIOUS_DAY_TAPPED = "previous_day_tapped"
    case DATE_CHANGE_TAPPED = "date_change_tapped"
}

enum TrackingEventParameter : String {
    case SELECTED_REGION = "selected_region"
}
