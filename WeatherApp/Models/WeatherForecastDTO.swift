//
//  WeatherForecastDTO.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 06/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import CoreLocation

class WeatherForecastDTO: NSObject, Codable, NSCoding {
    var city: City
    var list: [Forecast]
    var date: Date?
    
    static func forecastEndpointByCity(_ city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func forecastEndpointByCity(_ coords: CLLocation) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?lat=\(coords.coordinate.latitude)&lon=\(coords.coordinate.longitude)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func iconUrl(_ icon: String) -> String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    required init(coder decoder: NSCoder) {
        city = decoder.decodeObject(forKey: "cityName") as! City
        list = decoder.decodeObject(forKey: "list") as! [Forecast]
        date = decoder.decodeObject(forKey: "date") as! Date?
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(city, forKey: "cityName")
        encoder.encode(list, forKey: "list")
        if let date = date {
            encoder.encode(date, forKey: "date")
        }
    }
}

class City: NSObject, Codable, NSCoding {
    var name: String
    
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: "name") as! String
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(name, forKey: "name")
    }
}

class Forecast: NSObject, Codable, NSCoding {
    var main: Main
    var weather: [Weather]
    var dt: TimeInterval
    
    required init(coder decoder: NSCoder) {
        main = decoder.decodeObject(forKey: "main") as! Main
        weather = decoder.decodeObject(forKey: "weather") as! [Weather]
        dt = decoder.decodeDouble(forKey: "dt")
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(main, forKey: "main")
        encoder.encode(weather, forKey: "weather")
        encoder.encode(dt, forKey: "dt")
    }
}
