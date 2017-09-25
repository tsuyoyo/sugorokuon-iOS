//
//  Program.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

class Program {
    
    init(startTime : Date,
         endTime: Date,
         title : String,
         subTitle : String?,
         personality : String?,
         description : String?,
         info : String?,
         url : String?,
         metas : [String : String]?) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.subTitle = subTitle
        self.personality = personality
        self.description = description
        self.info = info
        self.url = url
        self.metas = metas
    }
    
    let startTime : Date
    let endTime: Date
    let title: String
    let subTitle: String?
    let personality: String?
    let description: String?
    let info: String?
    let url: String?
    let metas: [String : String]?
    
    class Builder {
        var startTime : Date?
        var endTime: Date?
        var title: String?
        var subTitle: String?
        var personality: String?
        var description: String?
        var info: String?
        var url: String?
        var metas: [String : String]? = [:]
        
        func start(from : Date) -> Builder {
            self.startTime = from
            return self
        }
        
        func end(at : Date) -> Builder {
            self.endTime = at
            return self
        }
        
        func title(title: String) -> Builder {
            self.title = title
            return self
        }
        
        func subTitle(subTitle : String) -> Builder {
            self.subTitle = subTitle
            return self
        }
        
        func personality(personality : String) -> Builder {
            self.personality = personality
            return self
        }
        
        func description(description : String) -> Builder {
            self.description = description
            return self
        }
        
        func info(info : String) -> Builder {
            self.info = info
            return self
        }
        
        func url(url : String) -> Builder {
            self.url = url
            return self
        }
        
        func addMeta(name : String, value : String) -> Builder {
            self.metas = [name : value]
            return self
        }
        
        func build() -> Program? {
            if let start = startTime, let end = endTime, let t = title {
                return Program(startTime: start,
                               endTime: end,
                               title: t,
                               subTitle: subTitle,
                               personality: personality,
                               description: description,
                               info: info,
                               url: url,
                               metas: metas)
            } else {
                return nil
            }
        }
    }
}
