//
//  CitiesDataSource.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 08/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import Foundation
import UIKit

class CitiesDataSource: NSObject, UITableViewDataSource {
    var locations: [Location] = [Location]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, commit action: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (action == .delete) {
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DatabaseService.locations = locations
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationIdentifier", for: indexPath) as! CityCell
        let location: Location = locations[indexPath.row]

        cell.setLocation(location)
                
        if (location.active) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
                                
        return cell
    }
}
