//
//  CachedCity.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

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
