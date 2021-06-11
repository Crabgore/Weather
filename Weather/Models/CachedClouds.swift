//
//  CachedClouds.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedClouds: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var all = RealmOptional<Int>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
