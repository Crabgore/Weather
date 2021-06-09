//
//  MyLocationManager.swift
//  Weather
//
//  Created by Mihail on 08.06.2021.
//

import Foundation
import CoreLocation

public class MyLocationManager: NSObject, CLLocationManagerDelegate {

    public static let shared = MyLocationManager()
    var callback: (() -> ())?
    
    var locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    public func requestWhenInUse(callback: (() -> ())?) {
        self.callback = callback
        locationManager.requestWhenInUseAuthorization()
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse) {
            callback!()
        }
    }
}
