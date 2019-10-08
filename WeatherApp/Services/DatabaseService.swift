//
//  DatabaseService.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 08/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation

class DatabaseService {
    let weatherDB = UserDefaults.standard
    let halfHourInSeconds: Double = 60 * 30

    func saveForecast(_ forecast: WeatherForecastDTO) -> Void {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: forecast, requiringSecureCoding: false)
            weatherDB.set(data, forKey: "\(forecast.city.name)-forecast")
            weatherDB.synchronize()
        } catch {
            NSLog("Error saving forecast")
        }
    }
    
    func saveWeather(_ weather: WeatherDTO) -> Void {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weather, requiringSecureCoding: false)
            weatherDB.set(data, forKey: "\(weather.name)-weather")
            weatherDB.synchronize()
        } catch {
            NSLog("Error saving weather")
        }
    }
    
    func getCachedForecast(_ city: String) -> WeatherForecastDTO? {
        let data = weatherDB.object(forKey: "\(city)-forecast") as! Data
        do {
            let forecast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherForecastDTO
            if let date = forecast.date?.timeIntervalSinceNow {
                if (date < halfHourInSeconds) {
                    return forecast
                }
            }
            return nil
        } catch {
            NSLog("error")
            return nil
        }
    }
    
    func getCachedWeather(_ city: String) -> WeatherDTO? {
        let data = weatherDB.object(forKey: "\(city)-weather") as! Data
        do {
            let weather = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherDTO
            if let date = weather.date?.timeIntervalSinceNow {
                if (date <= halfHourInSeconds) {
                    return weather
                }
            }
            return nil
        } catch {
            NSLog("error")
            return nil
        }
    }
}
