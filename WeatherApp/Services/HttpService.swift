//
//  HttpService.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation

class HttpService {
    static let API_KEY = "c52ed41e6b828d41c7a301e0e191d409"
    
    func weatherByCity(_ city: String, completionHandler: @escaping (_ weather: WeatherDTO) -> Void) {
        let cachedWeather = DatabaseService.getCachedWeather(city)

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
                    DatabaseService.saveWeather(weather)
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
        let cachedForecast = DatabaseService.getCachedForecast(city)
        
        if let forecast = cachedForecast {
            completionHandler(forecast)
            return
        }
        
        NSLog("City: \(city)")
        
        let url: URL? = URL(string: WeatherForecastDTO.forecastEndpointByCity(city))

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weatherForecast = try decoder.decode(WeatherForecastDTO.self, from: data!)
                DispatchQueue.main.async {
                    weatherForecast.date = Date()
                    DatabaseService.saveForecast(weatherForecast)
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
