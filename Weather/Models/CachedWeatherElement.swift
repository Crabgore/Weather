//
//  CachedWeatherElement.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

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
