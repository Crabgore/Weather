//
//  CachedCoord.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedCoord: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var lat = RealmOptional<Double>()
    dynamic var lon = RealmOptional<Double>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
