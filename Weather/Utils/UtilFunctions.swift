//
//  UtilFunctions.swift
//  Weather
//
//  Created by Mihail on 12.07.2021.
//

import Foundation

func getProperDesc(desc: String) -> String {
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

func getProperCurrentTemp(receivedTemp: Double) -> String {
    if Settings.temp == 1 {
        let temp = (receivedTemp * 1.8) + 32
        return String(format: "%.0f", temp) + "°"
    } else {
        return String(format: "%.0f", receivedTemp) + "°"
    }
}

func getProperMinMaxTemp(receivedMinTemp: Double, receivedMaxTemp: Double) -> String {
    if Settings.temp == 1 {
        let minTemp = (receivedMinTemp * 1.8) + 32
        let maxTemp = (receivedMaxTemp * 1.8) + 32
        if String(format: "%.0f", minTemp) == String(format: "%.0f", maxTemp) {
            return String(format: "%.0f", minTemp) + "°"
        } else {
            return String(format: "%.0f", minTemp) + "°-" + String(format: "%.0f", maxTemp) + "°"
        }
    } else {
        if String(format: "%.0f", receivedMinTemp) == String(format: "%.0f", receivedMaxTemp) {
            return String(format: "%.0f", receivedMinTemp) + "°"
        } else {
            return String(format: "%.0f", receivedMinTemp) + "°-" + String(format: "%.0f", receivedMaxTemp) + "°"
        }
    }
}
