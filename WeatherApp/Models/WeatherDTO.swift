//
//  Weather.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import CoreLocation

class WeatherDTO: NSObject, Codable, NSCoding {
    var name: String
    var weather: [Weather]
    var main: Main
    var date: Date?
    
    static func weatherEndpointByCity(_ city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func weatherEndpointByLocation(_ coords: CLLocation) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(coords.coordinate.latitude)&lon=\(coords.coordinate.longitude)&units=metric&APPID=\(HttpService.API_KEY)"
    }
    
    static func iconUrl(_ icon: String) -> String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: "cityName") as! String
        weather = decoder.decodeObject(forKey: "weather") as! [Weather]
        main = decoder.decodeObject(forKey: "main") as! Main
        date = decoder.decodeObject(forKey: "date") as! Date?
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(name, forKey: "cityName")
        encoder.encode(weather, forKey: "weather")
        encoder.encode(main, forKey: "main")
        if let date = date {
            encoder.encode(date, forKey: "date")
        }
    }
}

class Weather: NSObject, Codable, NSCoding {
    enum CodingKeys: String, CodingKey {
      case main
      case weatherDescription = "description"
      case icon
    }

    var main: String
    var weatherDescription: String?
    var icon: String
    
    required init(coder decoder: NSCoder) {
        main = decoder.decodeObject(forKey: "main") as! String
        weatherDescription = decoder.decodeObject(forKey: "weatherDescription") as! String?
        icon = decoder.decodeObject(forKey: "icon") as! String
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(main, forKey: "main")
        encoder.encode(icon, forKey: "icon")
        if let weatherDescription = weatherDescription {
            encoder.encode(weatherDescription, forKey: "weatherDescription")
        }
    }
}

class Main: NSObject, Codable, NSCoding {
    var temp: Float
    var humidity: Int
    
    required init(coder decoder: NSCoder) {
        temp = decoder.decodeFloat(forKey: "temp")
        humidity = decoder.decodeInteger(forKey: "humidity")
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(temp, forKey: "temp")
        encoder.encode(humidity, forKey: "humidity")
    }
}
