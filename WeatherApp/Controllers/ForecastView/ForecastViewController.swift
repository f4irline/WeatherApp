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
        httpService.weatherForecastByCity("Tampere", completionHandler: forecastCompleted)
        forecastTable.dataSource = forecastDataSource
        // Do any additional setup after loading the view.
    }


    func forecastCompleted(forecast: WeatherForecastDTO) {
        for date in forecast.list {
            forecastDataSource.forecast.append("\(date.weather.last!.main)")
        }
        
        forecastTable.reloadData()
    }
}

