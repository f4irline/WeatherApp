//
//  DatabaseService.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 08/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation

final class DatabaseService {
    static let locationDB = UserDefaults.standard
    static var locations: [Location]?
    let weatherDB = UserDefaults.standard
    let uiDB = UserDefaults.standard
    let halfHourInSeconds: Double = 60 * 30

    func getTabIndex() -> Int? {
        if let data = uiDB.object(forKey: "selectedTabIndex") as? Data {
            do {
                let index = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Int
                return index
            } catch {
                NSLog("Error initializing tab index")
                return nil
            }
        }
        return nil
    }
    
    func saveTabIndex(_ tabIndex: Int) {
        do {
            let index = try NSKeyedArchiver.archivedData(withRootObject: tabIndex, requiringSecureCoding: false)
            uiDB.set(index, forKey: "selectedTabIndex")
        } catch {
            NSLog("Error saving selected tab index")
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
    
    func saveWeather(_ weather: WeatherDTO) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weather, requiringSecureCoding: false)
            weatherDB.set(data, forKey: "\(weather.name)-weather")
            weatherDB.synchronize()
            NSLog("Saved weather, city: \(weather.name), date: \(String(describing: weather.date?.description))")
        } catch {
            NSLog("Error saving weather")
        }
    }
    
    func saveForecast(_ forecast: WeatherForecastDTO) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: forecast, requiringSecureCoding: false)
            weatherDB.set(data, forKey: "\(forecast.city.name)-forecast")
            weatherDB.synchronize()
            NSLog("Saved forecast, city: \(forecast.city.name), date: \(String(describing: forecast.date?.description))")
        } catch {
            NSLog("Error saving forecast")
        }
    }
    
    func getCachedWeather(_ city: String) -> WeatherDTO? {
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
    
    func getCachedForecast(_ city: String) -> WeatherForecastDTO? {
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
