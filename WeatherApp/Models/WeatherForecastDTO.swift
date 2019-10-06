//
//  WeatherForecastDTO.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 06/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import CoreLocation

struct WeatherForecastDTO: Codable {
    var city: City
    var list: [Forecast]
    
    static func forecastEndpointByCity(_ city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func forecastEndpointByCity(_ coords: CLLocation) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?lat=\(coords.coordinate.latitude)&lon=\(coords.coordinate.longitude)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func iconUrl(_ icon: String) -> String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

struct City: Codable {
    var name: String
}

struct Forecast: Codable {
    var main: Main
    var weather: [Weather]
    var dt: TimeInterval
}
