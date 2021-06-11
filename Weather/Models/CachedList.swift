//
//  CachedList.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedList: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var dt = RealmOptional<Int>()
    dynamic var main: CachedMain?
    dynamic var weather = List<CachedWeatherElement>()
    dynamic var clouds: CachedClouds?
    dynamic var wind: CachedWind?
    dynamic var visibility = RealmOptional<Int>()
    dynamic var pop = RealmOptional<Double>()
    dynamic var rain: CachedRain?
    dynamic var sys: CachedSys?
    dynamic var dtTxt: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}
