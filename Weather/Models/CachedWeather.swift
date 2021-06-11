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
