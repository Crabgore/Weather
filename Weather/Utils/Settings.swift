//
//  Settings.swift
//  Weather
//
//  Created by Mihail on 09.07.2021.
//

import Foundation

final class Settings {
    static var TEMP = "temp"
    static var SPEED = "speed"
    static var TIME = "time"
    static var IS_PERMITTED = "time"
    static var CITY = "city"
    static var IS_APP_LAUNCHED_ONCE = "isAppAlreadyLaunchedOnce"
    
    static var temp: Int {
        get {
            return UserDefaults.standard.integer(forKey: TEMP)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TEMP)
        }
    }
    
    static var speed: Int {
        get {
            return UserDefaults.standard.integer(forKey: SPEED)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SPEED)
        }
    }
    
    static var time: Int {
        get {
            return UserDefaults.standard.integer(forKey: TIME)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TIME)
        }
    }
    
    static var city: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: CITY) ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: CITY)
        }
    }
    
    static var isPermitted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: IS_PERMITTED)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: IS_PERMITTED)
        }
    }
    
    static var isAppLaunchedOnce: Bool {
        get {
            return UserDefaults.standard.bool(forKey: IS_APP_LAUNCHED_ONCE)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: IS_APP_LAUNCHED_ONCE)
        }
    }
}
