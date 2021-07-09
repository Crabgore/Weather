//
//  RealmInspector.swift
//  Weather
//
//  Created by Mihail on 09.07.2021.
//

import Foundation

protocol RealmInspector {
    func saveWeather(response: Weather?, cityId: String?)
    func getWeather(id: String) -> Weather?
}
