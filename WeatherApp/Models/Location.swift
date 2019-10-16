//
//  Location.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 08/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, NSCoding {
    var city: String = "Use GPS"
    var coordinates: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var active: Bool = false
    
    override init() {}
    
    required init(coder decoder: NSCoder) {
        super.init()
        city = decoder.decodeObject(forKey: "cityName") as! String
        coordinates = decoder.decodeObject(forKey: "coordinates") as! CLLocation
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(city, forKey: "cityName")
        encoder.encode(coordinates, forKey: "coordinates")
    }
}
