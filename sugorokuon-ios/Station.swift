//
//  Station.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

//<station>
//<id>FMT</id>
//<name>TOKYO FM</name>
//<ascii_name>TOKYO FM</ascii_name>
//<areafree>1</areafree>
//<timefree>1</timefree>
//<logo width="224" height="100" align="lrtrim">
//https://radiko.jp/v2/static/station/logo/FMT/lrtrim/224x100.png
//</logo>
//<logo width="258" height="60" align="lrtrim">
//https://radiko.jp/v2/static/station/logo/FMT/lrtrim/258x60.png
//</logo>
//<logo width="448" height="200" align="lrtrim">
//https://radiko.jp/v2/static/station/logo/FMT/lrtrim/448x200.png
//</logo>
//<logo width="688" height="160" align="lrtrim">
//https://radiko.jp/v2/static/station/logo/FMT/lrtrim/688x160.png
//</logo>
//<logo width="224" height="100" align="center">
//https://radiko.jp/v2/static/station/logo/FMT/224x100.png
//</logo>
//<logo width="258" height="60" align="center">
//https://radiko.jp/v2/static/station/logo/FMT/258x60.png
//</logo>
//<logo width="448" height="200" align="center">
//https://radiko.jp/v2/static/station/logo/FMT/448x200.png
//</logo>
//<logo width="688" height="160" align="center">
//https://radiko.jp/v2/static/station/logo/FMT/688x160.png
//</logo>
//<banner>
//https://radiko.jp/res/banner/FMT/20161013150235.png
//</banner>
//<href>http://www.tfm.co.jp/</href>
//</station>

import Foundation

class Station {

    init(id: String,
         name: String,
         asciiName: String,
         providerType: ProviderType,
         siteUrl: String,
         logoUrl: String,
         bannerUrl: String?,
         feed: String?,
         isOnAirSongsAvailable: Bool,
         logos: Array<StationLogo>) {
        self.id = id
        self.name = name
        self.asciiName = asciiName
        self.providerType = providerType
        self.siteUrl = siteUrl
        self.logoUrl = logoUrl
        self.bannerUrl = bannerUrl
        self.feed = feed
        self.isOnAirSongsAvailable = isOnAirSongsAvailable
        self.logos = logos
    }
    
    let id: String
    
    let name: String
    
    let asciiName: String
    
    let providerType: ProviderType
    
    let siteUrl: String
    
    let logoUrl: String
    
    let bannerUrl: String?
    
    let feed: String?
    
    let isOnAirSongsAvailable: Bool
    
    let logos: Array<StationLogo>
    
    class Builder {
        private var id: String = ""
        private var name: String = ""
        private var asciiName: String = ""
        private var providerType: ProviderType = .Radiko
        private var siteUrl: String = ""
        private var logoUrl: String = ""
        private var bannerUrl: String?
        private var feed: String?
        private var isOnAirSongsAvailable: Bool?
        private var logos: Array<StationLogo> = Array()
        
        func id(id: String) -> Builder {
            self.id = id
            return self
        }
        
        func name(name: String) -> Builder {
            // In some radio station, space is recognized as splitter
            // (e.g. "TBS radio" is parsed separately "TBS" and "radio"
            self.name += name
            return self
        }
        
        func asciiName(asciiName: String) -> Builder {
            self.asciiName = asciiName
            return self
        }
        
        func siteUrl(siteUrl: String) -> Builder {
            self.siteUrl = siteUrl
            return self
        }
        
        func logoUrl(logoUrl: String) -> Builder {
            self.logoUrl = logoUrl
            return self
        }
        
        func bannerUrl(bannerUrl: String) -> Builder {
            self.bannerUrl = bannerUrl
            return self
        }
        
        func feed(feed: String) -> Builder {
            self.feed = feed
            return self
        }
        
        func isOnAirSongsAvailable(isOnAirSongsAvailable: Bool) -> Builder {
            self.isOnAirSongsAvailable = isOnAirSongsAvailable
            return self
        }
        
        func addLogo(logo: StationLogo) -> Builder {
            self.logos.append(logo)
            return self
        }
        
        func build() -> Station {
            return Station(id: id,
                           name: name,
                           asciiName: asciiName,
                           providerType: providerType,
                           siteUrl: siteUrl,
                           logoUrl: logoUrl,
                           bannerUrl: bannerUrl,
                           feed: feed,
                           isOnAirSongsAvailable: isOnAirSongsAvailable ?? false,
                           logos: logos)
        }
    }
}
