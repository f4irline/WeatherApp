//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    let locationsDataSource: CitiesDataSource = CitiesDataSource()
    var locations: [Location]?

    @IBOutlet weak var citiesTable: UITableView!
    @IBOutlet weak var newLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = DatabaseService.locations
        
        citiesTable.dataSource = locationsDataSource
        
        if let locations = self.locations {            
            locationsDataSource.locations = locations
        }
                
        citiesTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let location = Location()
        if let name = newLocation.text {
            location.city = name
            location.active = true
            locationsDataSource.locations.append(location)
            DatabaseService.locations?.append(location)
            
            citiesTable.reloadData()
        }

        newLocation.text = ""
    }
}

