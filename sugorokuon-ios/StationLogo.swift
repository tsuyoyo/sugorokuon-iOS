//
//  StationLogo.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/03.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class StationLogo {
    
    init(width: Int, height: Int, url: String) {
        self.width = width
        self.height = height
        self.url = url
    }
    
    let width: Int
    let height: Int
    let url: String
    
    class Builder {
        private var width: Int?
        private var height: Int?
        private var url: String?
        
        func width(width: Int) -> Builder {
            self.width = width
            return self
        }
        
        func height(height: Int) -> Builder {
            self.height = height
            return self
        }
        
        func url(url: String) -> Builder {
            self.url = url
            return self
        }
        
        func build() -> StationLogo {
            return StationLogo(
                width: width ?? 0,
                height: height ?? 0,
                url: url ?? "")
        }
    }
}
