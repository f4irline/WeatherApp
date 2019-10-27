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
    static let uiDB = UserDefaults.standard
    static let halfHourInSeconds: Double = 60 * 30
    static var locations: [Location]?
    static var selectedTabIndex: Int?
    
    static func initCache() {
        self.initLocations()
        self.initTabIndex()
    }

    static func saveCache() {
        self.saveLocations()
        self.saveTabIndex()
    }
    
    static func initTabIndex() {
        if let data = uiDB.object(forKey: "selectedTabIndex") as? Data {
            do {
                let index = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Int
                self.selectedTabIndex = index
            } catch {
                NSLog("Error initializing tab index")
            }
        }
    }
    
    static func saveTabIndex() {
        if let selectedTabIndex = self.selectedTabIndex {
            print(selectedTabIndex)
            do {
                let index = try NSKeyedArchiver.archivedData(withRootObject: selectedTabIndex, requiringSecureCoding: false)
                uiDB.set(index, forKey: "selectedTabIndex")
            } catch {
                NSLog("Error saving selected tab index")
            }
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
            gps.active = true
            locations?.append(gps)
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
    
    static func saveWeather(_ weather: WeatherDTO) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weather, requiringSecureCoding: false)
            weatherDB.set(data, forKey: "\(weather.name)-weather")
            weatherDB.synchronize()
            NSLog("Saved weather, city: \(weather.name), date: \(String(describing: weather.date?.description))")
        } catch {
            NSLog("Error saving weather")
        }
    }
    
    static func saveForecast(_ forecast: WeatherForecastDTO) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: forecast, requiringSecureCoding: false)
            weatherDB.set(data, forKey: "\(forecast.city.name)-forecast")
            weatherDB.synchronize()
            NSLog("Saved forecast, city: \(forecast.city.name), date: \(String(describing: forecast.date?.description))")
        } catch {
            NSLog("Error saving forecast")
        }
    }
    
    static func getCachedWeather(_ city: String) -> WeatherDTO? {
        if let data = weatherDB.object(forKey: "\(city)-weather") as? Data {
            do {
                let weather = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherDTO
                if let date = weather.date?.timeIntervalSinceNow {
                    if (abs(date) <= halfHourInSeconds) {
                        NSLog("Got cached weather, city: \(city), date: \(abs(date))")
                        return weather
                    }
                    return nil
                }
                return nil
            } catch {
                NSLog("Error getting cached weather")
                return nil
            }
        }
        return nil
    }
    
    static func getCachedForecast(_ city: String) -> WeatherForecastDTO? {
        if let data = weatherDB.object(forKey: "\(city)-forecast") as? Data {
            do {
                let forecast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherForecastDTO
                if let date = forecast.date?.timeIntervalSinceNow {
                    if (abs(date) <= halfHourInSeconds) {
                        NSLog("Got cached forecast, city: \(city), date: \(abs(date))")
                        return forecast
                    }
                    return nil
                }
                return nil
            } catch {
                NSLog("Error getting cached forecast")
                return nil
            }
        }
        return nil
    }
}
