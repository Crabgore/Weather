//
//  CachedMain.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedMain: Object {
    dynamic var id: String?
    dynamic var temp = RealmOptional<Double>()
    dynamic var feelsLike = RealmOptional<Double>()
    dynamic var tempMin = RealmOptional<Double>()
    dynamic var tempMax = RealmOptional<Double>()
    dynamic var pressure = RealmOptional<Int>()
    dynamic var seaLevel = RealmOptional<Int>()
    dynamic var grndLevel = RealmOptional<Int>()
    dynamic var humidity = RealmOptional<Int>()
    dynamic var tempKf = RealmOptional<Double>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
