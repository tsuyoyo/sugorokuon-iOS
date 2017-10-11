//
//  Program.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/09/02.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation
//<prog id="8648655101" master_id="" ft="20170804050000" to="20170804070000" ftl="0500" tol="0700" dur="7200">
//<title>おはよう寺ちゃん　活動中</title>
//<url>http://www.joqr.co.jp/tera/</url>
//<failed_record>0</failed_record>
//<ts_in_ng>0</ts_in_ng>
//<ts_out_ng>0</ts_out_ng>
//<desc/>
//<info>
//<img src='http://www.joqr.co.jp/programs/images/20160420151838-lx9f2.jpg' style="max-width: 200px;"> <br /><br /><br/>番組前半の5時台はゆったり聴ける朝刊的コラム番組、後半の6時台はニュースに真正面から挑む報道系情報番組。合計、毎日2時間、生活に役立つ情報を時間の許す限りリスナーにお伝えしていきます。<br/><br/>【コメンテーター】<br/>東谷暁<br/>（ジャーナリスト）<br/>【おはよう大発見】<br/>鈴木洋嗣<br/>（文藝春秋発行人）<br/>【おはようコロンブス】<br/>松井一晃<br/>（ナンバー編集長）<br/><br/>番組メールアドレス：<br/><a href="mailto:tera@joqr.net">tera@joqr.net</a><br/>番組Webページ：<br/><a href="http://www.joqr.co.jp/tera/">http://www.joqr.co.jp/tera/</a><br/><br/><b>コーナー番組サイト</b><br/><a href="http://www.joqr.net/blog/ecoful/"target="_blank">文化放送GREENWORKSエコライフ情報</a><br/><br/>twitterハッシュタグは「<a href="http://twitter.com/#!/search/%23joqr">#joqr</a>」<br/>twitterアカウントは「<a href="http://twitter.com/#!/tera1134">@tera1134</a>」<br/>facebookページは「<a href='http://www.facebook.com/1134joqr'>http://www.facebook.com/1134joqr</a>」<br/>
//</info>
//<pfm>寺島尚正 東谷暁 鈴木洋嗣</pfm>
//<img>
//https://radiko.jp/res/program/DEFAULT_IMAGE/QRR/cl_20160929121837_1362801.png
//</img>
//<metas>
//<meta name="twitter" value="#joqr"/>
//<meta name="twitter" value="from:tera1134"/>
//</metas>
//</prog>
class Program {
    
    init(startTime : Date,
         endTime: Date,
         title : String,
         personality : String?,
         description : String?,
         info : String?,
         url : String?,
         image: String?,
         metas : [String : String]?) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.personality = personality
        self.description = description
        self.info = info
        self.url = url
        self.image = image
        self.metas = metas
    }
    
    let startTime : Date
    let endTime: Date
    let title: String
    let personality: String?
    let description: String?
    let info: String?
    let url: String?
    let image: String?
    let metas: [String : String]?
    
    class Builder {
        var startTime : Date?
        var endTime: Date?
        var title: String?
        var personality: String?
        var description: String?
        var info: String?
        var url: String?
        var image: String?
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
        
        func image(image: String) -> Builder {
            self.image = image
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
                               personality: personality,
                               description: description,
                               info: info,
                               url: url,
                               image: image,
                               metas: metas)
            } else {
                return nil
            }
        }
    }
}
