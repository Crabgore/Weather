//
//  CachedSys.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedSys: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var pod: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}
