//
//  ForecastDataSource.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 06/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit

class ForecastDataSource: NSObject, UITableViewDataSource {
    var forecast: [Forecast] = [Forecast]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let date: Forecast = forecast[indexPath.row]
        let imageUrl: URL? = URL(string: WeatherForecastDTO.iconUrl(date.weather.last!.icon))
        let isoDate = Date(timeIntervalSince1970: date.dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy, h:mm a"
        
        cell.textLabel?.text = "\(date.weather.last!.main) \(date.main.temp) \u{00B0}C"
        cell.detailTextLabel?.text = "\(formatter.string(from: isoDate))"
        cell.imageView?.loadURL(imageUrl!, completeHandler: {() -> Void in
            cell.layoutSubviews()
        })

        return cell
    }
}
