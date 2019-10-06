//
//  ForecastDataSource.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 06/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit

class ForecastDataSource: NSObject, UITableViewDataSource {
    var forecast: [String] = [String]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        cell.textLabel?.text = forecast[indexPath.row]
        
        return cell
    }
}
