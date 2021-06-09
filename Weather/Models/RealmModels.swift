//
//  RealmModels.swift
//  Weather
//
//  Created by Mihail on 09.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedWeather: Object {
    dynamic var id: String?
    dynamic var cod: String?
    dynamic var message = RealmOptional<Int>()
    dynamic var cnt = RealmOptional<Int>()
    dynamic var list = List<CachedList>()
    dynamic var city: CachedCity?

    override static func primaryKey() -> String? {
        return "id"
    }
}

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

@objcMembers class CachedCity: Object {
    dynamic var ident: String = UUID().uuidString
    dynamic var id = RealmOptional<Int>()
    dynamic var name: String?
    dynamic var coord: CachedCoord?
    dynamic var country: String?
    dynamic var timezone = RealmOptional<Int>()
    dynamic var sunrise = RealmOptional<Int>()
    dynamic var sunset = RealmOptional<Int>()

    override static func primaryKey() -> String? {
        return "ident"
    }
}

@objcMembers class CachedCoord: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var lat = RealmOptional<Double>()
    dynamic var lon = RealmOptional<Double>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

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

@objcMembers class CachedWeatherElement: Object {
    dynamic var ident: String = UUID().uuidString
    dynamic var id = RealmOptional<Int>()
    dynamic var main: String?
    dynamic var weatherDescription: String?
    dynamic var icon: String?

    override static func primaryKey() -> String? {
        return "ident"
    }
}

@objcMembers class CachedClouds: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var all = RealmOptional<Int>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

@objcMembers class CachedWind: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var speed = RealmOptional<Double>()
    dynamic var deg = RealmOptional<Int>()
    dynamic var gust = RealmOptional<Double>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

@objcMembers class CachedRain: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var the3H = RealmOptional<Double>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

@objcMembers class CachedSys: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var pod: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}
