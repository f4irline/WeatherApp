//
//  DatabaseService.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 08/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation

final class DatabaseService {
    static let weatherDB = UserDefaults.standard
    static let locationDB = UserDefaults.standard
    static let halfHourInSeconds: Double = 60 * 30
    static var lastForecast: WeatherForecastDTO?
    static var lastWeather: WeatherDTO?
    static var locations: [Location]?
    static var currentLocation: Location?
    
    static func initCache() {
        self.initCurrentLocation()
        self.initLocations()
        self.initLastWeather()
        self.initLastForecast()
    }
    
    static func saveCache() {
        self.saveLocation()
        self.saveLocations()
        self.saveWeather()
        self.saveForecast()
    }
    
    static func initCurrentLocation() {
        if let data = locationDB.object(forKey: "location") as? Data {
            do {
                let location = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Location
                self.currentLocation = location
                NSLog("Initialized current location")
            } catch {
                NSLog("Error getting cached location")
            }
        } else {
            currentLocation = Location()
        }
    }
    
    static func initLocations() {
        if let data = locationDB.object(forKey: "locations") as? Data {
            do {
                let locations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Location]
                self.locations = locations
                NSLog("Initialized locations")
            } catch {
                NSLog("Error getting cached locations")
            }
        } else {
            locations = [Location]()
            
            let gps = Location()
            locations?.append(gps)
        }
    }
    
    static func initLastWeather() {
        if let location = self.currentLocation,
            let data = weatherDB.object(forKey: "\(location.city)-weather") as? Data {
            do {
                let weather = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherDTO
                if let date = weather.date?.timeIntervalSinceNow {
                    if (date <= halfHourInSeconds) {
                        self.lastWeather = weather
                        NSLog("Got weather: \(String(describing: weather.date?.description))")
                    }
                }
            } catch {
                NSLog("Error getting cached weather")
            }
        }
    }
    
    static func initLastForecast() {
        if let location = self.currentLocation,
            let data = weatherDB.object(forKey: "\(location.city)-forecast") as? Data {
            do {
                let forecast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherForecastDTO
                if let date = forecast.date?.timeIntervalSinceNow {
                    if (date <= halfHourInSeconds) {
                        self.lastForecast = forecast
                        NSLog("Got weather: \(String(describing: forecast.date?.description))")
                    }
                }
            } catch {
                NSLog("Error getting cached forecast")
            }
        }
    }
        
    static func saveLocation() {
        if let location = self.currentLocation {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false)
                locationDB.set(data, forKey: "location")
                locationDB.synchronize()
                NSLog("Saved location: \(location.city)")
            } catch {
                NSLog("Error saving location")
            }
        }
    }
    
    static func saveLocations() {
        if let locations = self.locations {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: locations, requiringSecureCoding: false)
                locationDB.set(data, forKey: "locations")
                locationDB.synchronize()
                NSLog("Saved locations.")
            } catch {
                NSLog("Error saving locations")
            }
        }
    }
    
    static func saveWeather() {
        if let weather = self.lastWeather {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: weather, requiringSecureCoding: false)
                weatherDB.set(data, forKey: "\(weather.name)-weather")
                weatherDB.synchronize()
                NSLog("Saved weather: \(String(describing: weather.date?.description))")
            } catch {
                NSLog("Error saving weather")
            }
        }
    }
    
    static func saveForecast() {
        if let forecast = self.lastForecast {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: forecast, requiringSecureCoding: false)
                weatherDB.set(data, forKey: "\(forecast.city.name)-forecast")
                weatherDB.synchronize()
                NSLog("Saved forecast: \(String(describing: forecast.date?.description))")
            } catch {
                NSLog("Error saving forecast")
            }
        }
    }
    
    static func getCachedWeather() -> WeatherDTO? {
        if let weather = self.lastWeather {
            if let date = weather.date?.timeIntervalSinceNow {
                if (date <= halfHourInSeconds) {
                    return weather
                }
            }
            return nil
        }
        return nil
    }
    
    static func getCachedForecast() -> WeatherForecastDTO? {
        if let forecast = self.lastForecast {
            if let date = forecast.date?.timeIntervalSinceNow {
                if (date <= halfHourInSeconds) {
                    return forecast
                }
            }
            return nil
        }
        return nil
    }
}
