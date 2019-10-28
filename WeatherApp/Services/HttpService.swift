//
//  HttpService.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation
import CoreLocation

class HttpService {
    static let API_KEY = "c52ed41e6b828d41c7a301e0e191d409"
    let databaseService = DatabaseService()
    
    func weatherByCity(_ city: String, completionHandler: @escaping (_ weather: WeatherDTO) -> Void) {
        let city = city.replacingOccurrences(of: " ", with: "+")
        let cachedWeather = databaseService.getCachedWeather(city)

        if let weather = cachedWeather {
            completionHandler(weather)
            return
        }
                            
        let url: URL? = URL(string: WeatherDTO.weatherEndpointByCity(city))
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
                
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherDTO.self, from: data!)
                DispatchQueue.main.async {
                    weather.date = Date()
                    self.databaseService.saveWeather(weather)
                    completionHandler(weather)
                }
            } catch {
                NSLog("Error trying to convert data to JSON")
                print(error)
            }
        }
                
        let task = session.dataTask(with: url!, completionHandler: parseJson)
        
        task.resume()
    }
    
    func weatherByLocation(_ location: CLLocation, completionHandler: @escaping (_ weather: WeatherDTO) -> Void) {
        let url: URL? = URL(string: WeatherDTO.weatherEndpointByLocation(location))
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
                
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherDTO.self, from: data!)
                DispatchQueue.main.async {
                    weather.date = Date()
                    self.databaseService.saveWeather(weather)
                    completionHandler(weather)
                }
            } catch {
                NSLog("Error trying to convert data to JSON")
                print(error)
            }
        }
                
        let task = session.dataTask(with: url!, completionHandler: parseJson)
        
        task.resume()
    }
    
    func weatherForecastByCity(_ city: String, completionHandler: @escaping (_ weather: WeatherForecastDTO) -> Void) {
        let city = city.replacingOccurrences(of: " ", with: "+")
        let cachedForecast = databaseService.getCachedForecast(city)
        
        if let forecast = cachedForecast {
            completionHandler(forecast)
            return
        }

        let url: URL? = URL(string: WeatherForecastDTO.forecastEndpointByCity(city))

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weatherForecast = try decoder.decode(WeatherForecastDTO.self, from: data!)
                DispatchQueue.main.async {
                    weatherForecast.date = Date()
                    self.databaseService.saveForecast(weatherForecast)
                    completionHandler(weatherForecast)
                }
            } catch {
                NSLog("Error trying to convert data to JSON")
                print(error)
            }
        }
                
        let task = session.dataTask(with: url!, completionHandler: parseJson)
        
        task.resume()
    }
    
    func weatherForecastByLocation(_ location: CLLocation, completionHandler: @escaping (_ weather: WeatherForecastDTO) -> Void) {
        let url: URL? = URL(string: WeatherForecastDTO.forecastEndpointByLocation(location))

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weatherForecast = try decoder.decode(WeatherForecastDTO.self, from: data!)
                DispatchQueue.main.async {
                    weatherForecast.date = Date()
                    self.databaseService.saveForecast(weatherForecast)
                    completionHandler(weatherForecast)
                }
            } catch {
                NSLog("Error trying to convert data to JSON")
                print(error)
            }
        }
                
        let task = session.dataTask(with: url!, completionHandler: parseJson)
        
        task.resume()
    }
}
