//
//  Weather.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import CoreLocation

struct WeatherDTO: Codable {
    var name: String
    var weather: [Weather]
    var main: Main
    
    static func weatherEndpointByCity(_ city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func weatherEndpointByCoordinates(_ coords: CLLocation) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(coords.coordinate.latitude)&lon=\(coords.coordinate.longitude)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func iconUrl(_ icon: String) -> String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

struct Weather: Codable {
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Float
    var humidity: Int
}
