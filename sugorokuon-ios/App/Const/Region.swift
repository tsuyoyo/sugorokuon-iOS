//
//  Region.swift
//  sugorokuon-ios
//
//  Created by tsuyoyo on 2017/10/10.
//  Copyright © 2017年 tsuyoyo. All rights reserved.
//

import Foundation

enum Region : String {
    case HOKKAIDO
    case AOMORI
    case IWATE
    case MIYAAGI
    case AKITA
    case YAMAGATA
    case FUKUSHIMA
    case IBARAKI
    case TOCHIGI
    case GUNMA
    case SAITAMA
    case CHIBA
    case TOKYO
    case KANAGAWA
    case NIIGATA
    case TOYAMA
    case ISHIKAWA
    case FUKUI
    case YAMANASHI
    case NAGANO
    case GIFU
    case SHIZUOKA
    case AICHI
    case MIE
    case SHIGA
    case KYOTO
    case OSAKA
    case HYOGO
    case NARA
    case WAKAYAMA
    case TOTTORI
    case SHIMANE
    case OKAYAMA
    case HIROSHIMA
    case YAMAGUCHI
    case TOKUSHIMA
    case KAGAWA
    case EHIME
    case KOUCHI
    case FUKUOKA
    case SAGA
    case NAGASAKI
    case KUMAMOTO
    case OITA
    case MIYAZAKI
    case KAGOSHIMA
    case OKINAWA
    case NO_REGION

    func value() -> (id : String, name : String) {
        switch self {
        case .HOKKAIDO: return (id: "JP1", name: "北海道")
        case .AOMORI: return (id: "JP2", name: "青森")
        case .IWATE: return (id: "JP3", name: "岩手")
        case .MIYAAGI: return (id: "JP4", name: "宮城")
        case .AKITA: return (id: "JP5", name: "秋田")
        case .YAMAGATA: return (id: "JP6", name: "山形")
        case .FUKUSHIMA: return (id: "JP7", name: "福島")
        case .IBARAKI: return (id: "JP8", name: "茨城")
        case .TOCHIGI: return (id: "JP9", name: "栃木")
        case .GUNMA: return (id: "JP10", name: "群馬")
        case .SAITAMA: return (id: "JP11", name: "埼玉")
        case .CHIBA: return (id: "JP12", name: "千葉")
        case .TOKYO: return (id: "JP13", name: "東京")
        case .KANAGAWA: return (id: "JP14", name: "神奈川")
        case .NIIGATA: return (id: "JP15", name: "新潟")
        case .TOYAMA: return (id: "JP16", name: "富山")
        case .ISHIKAWA: return (id: "JP17", name: "石川")
        case .FUKUI: return (id: "JP18", name: "福井")
        case .YAMANASHI: return (id: "JP19", name: "山梨")
        case .NAGANO: return (id: "JP20", name: "長野")
        case .GIFU: return (id: "JP21", name: "岐阜")
        case .SHIZUOKA: return (id: "JP22", name: "静岡")
        case .AICHI: return (id: "JP23", name: "愛知")
        case .MIE: return (id: "JP24", name: "三重")
        case .SHIGA: return (id: "JP25", name: "滋賀")
        case .KYOTO: return (id: "JP26", name: "京都")
        case .OSAKA: return (id: "JP27", name: "大阪")
        case .HYOGO: return (id: "JP28", name: "兵庫")
        case .NARA: return (id: "JP29", name: "奈良")
        case .WAKAYAMA: return (id: "JP30", name: "和歌山")
        case .TOTTORI: return (id: "JP31", name: "鳥取")
        case .SHIMANE: return (id: "JP32", name: "島根")
        case .OKAYAMA: return (id: "JP33", name: "岡山")
        case .HIROSHIMA: return (id: "JP34", name: "広島")
        case .YAMAGUCHI: return (id: "JP35", name: "山口")
        case .TOKUSHIMA: return (id: "JP36", name: "徳島")
        case .KAGAWA: return (id: "JP37", name: "香川")
        case .EHIME: return (id: "JP38", name: "愛媛")
        case .KOUCHI: return (id: "JP39", name: "高知")
        case .FUKUOKA: return (id: "JP40", name: "福岡")
        case .SAGA: return (id: "JP41", name: "佐賀")
        case .NAGASAKI: return (id: "JP42", name: "長崎")
        case .KUMAMOTO: return (id: "JP43", name: "熊本")
        case .OITA: return (id: "JP44", name: "大分")
        case .MIYAZAKI: return (id: "JP45", name: "宮崎")
        case .KAGOSHIMA: return (id: "JP46", name: "鹿児島")
        case .OKINAWA: return (id: "JP47", name: "沖縄")
        case .NO_REGION: return (id: "", name: "")
        }
    }
    
    static func getAllRegion() -> Array<Region> {
        return [
            Region.HOKKAIDO,
            Region.AOMORI,
            Region.IWATE,
            Region.MIYAAGI,
            Region.AKITA,
            Region.YAMAGATA,
            Region.FUKUSHIMA,
            Region.IBARAKI,
            Region.TOCHIGI,
            Region.GUNMA,
            Region.SAITAMA,
            Region.CHIBA,
            Region.TOKYO,
            Region.KANAGAWA,
            Region.NIIGATA,
            Region.TOYAMA,
            Region.ISHIKAWA,
            Region.FUKUI,
            Region.YAMANASHI,
            Region.NAGANO,
            Region.GIFU,
            Region.SHIZUOKA,
            Region.AICHI,
            Region.MIE,
            Region.SHIGA,
            Region.KYOTO,
            Region.OSAKA,
            Region.HYOGO,
            Region.NARA,
            Region.WAKAYAMA,
            Region.TOTTORI,
            Region.SHIMANE,
            Region.OKAYAMA,
            Region.HIROSHIMA,
            Region.YAMAGUCHI,
            Region.TOKUSHIMA,
            Region.KAGAWA,
            Region.EHIME,
            Region.KOUCHI,
            Region.FUKUOKA,
            Region.SAGA,
            Region.NAGASAKI,
            Region.KUMAMOTO,
            Region.OITA,
            Region.MIYAZAKI,
            Region.KAGOSHIMA,
            Region.OKINAWA,
        ]
    }
}
