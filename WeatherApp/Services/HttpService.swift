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
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url: URL? = URL(string: WeatherDTO.weatherEndpointByCity(city))
        
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherDTO.self, from: data!)
                DispatchQueue.main.async {
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
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url: URL? = URL(string: WeatherForecastDTO.forecastEndpointByCity(city))
        
        func parseJson(data: Data?, response: URLResponse?, error: Error?) {
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherForecastDTO.self, from: data!)
                DispatchQueue.main.async {
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
}
