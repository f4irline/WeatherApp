//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    let forecastDataSource: ForecastDataSource = ForecastDataSource()
    let httpService: HttpService = HttpService()

    @IBOutlet weak var forecastTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTable.dataSource = forecastDataSource
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let locations = DatabaseService.locations,
            let location = locations.first(where: { $0.active }) {
            if (location.city != "Use GPS") {
                httpService.weatherForecastByCity(location.city, completionHandler: forecastCompleted)
            }
        }
    }

    func forecastCompleted(forecast: WeatherForecastDTO) {
        forecastDataSource.forecast = []
        for date in forecast.list {
            forecastDataSource.forecast.append(date)
        }
        
        forecastTable.reloadData()
    }
}

