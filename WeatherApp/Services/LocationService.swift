//
//  LocationService.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 24/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import CoreLocation

import Foundation

class LocationService: CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    init() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
