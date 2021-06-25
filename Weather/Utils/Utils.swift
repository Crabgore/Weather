//
//  Utils.swift
//  Weather
//
//  Created by Mihail on 25.06.2021.
//

import Foundation

func properDesc(desc: String) -> String {
    var result = ""
    
    switch desc {
    case let str where str.contains("clear"):
        result = "Ясно"
    case let str where str.contains("clouds"):
        result = "Облачно"
    case let str where str.contains("rain"):
        result = "Дождь"
    case let str where str.contains("thunderstorm"):
        result = "Гроза"
    case let str where str.contains("snow"):
        result = "Снег"
    case let str where str.contains("mist"):
        result = "Туман"
    case let str where str.contains("drizzle"):
        result = "Морось"
    default:
        result = ""
    }
    
    return result
}
