//
//  CityCell.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 08/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    var location: Location?;

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        // Initialization code
    }

    @objc override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let location = self.location,
            let locationSwitch = self.accessoryView as? UISwitch {
            location.active = selected
            locationSwitch.setOn(selected, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func setLocation(_ location: Location) {
        self.location = location
        self.textLabel?.text = location.city
        
        let locationSwitch = UISwitch()
        locationSwitch.setOn(location.active, animated: true)
        locationSwitch.isUserInteractionEnabled = false

        self.accessoryView = locationSwitch
    }
}
