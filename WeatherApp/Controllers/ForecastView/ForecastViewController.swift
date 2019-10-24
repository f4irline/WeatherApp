//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate {
    let forecastDataSource: ForecastDataSource = ForecastDataSource()
    
    let spinner = SpinnerViewController()
    
    let locationManager = CLLocationManager()
    let httpService: HttpService = HttpService()

    @IBOutlet weak var forecastTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTable.dataSource = forecastDataSource
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = locations.last!
        httpService.weatherForecastByLocation(location, completionHandler: forecastCompleted)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startSpinner()
        if let locations = DatabaseService.locations,
            let location = locations.first(where: { $0.active }) {
            if (location.city != "Use GPS") {
                httpService.weatherForecastByCity(location.city, completionHandler: forecastCompleted)
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetView()
    }
    
    func startSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    func resetView() {
        forecastDataSource.forecast = []
        forecastTable.reloadData()
    }

    func forecastCompleted(forecast: WeatherForecastDTO) {
        forecastDataSource.forecast = []
        for date in forecast.list {
            forecastDataSource.forecast.append(date)
        }
        
        forecastTable.reloadData()
        stopSpinner()
    }
}

