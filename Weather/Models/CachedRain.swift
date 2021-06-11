//
//  CachedRain.swift
//  Weather
//
//  Created by Mihail on 11.06.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedRain: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var the3H = RealmOptional<Double>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
