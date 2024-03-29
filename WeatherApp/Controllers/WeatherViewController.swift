//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tommi Lepola on 05/10/2019.
//  Copyright © 2019 Tommi Lepola. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
    let locationManager = CLLocationManager()
    let httpService: HttpService = HttpService()

    let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = locations.last!
        httpService.weatherByLocation(location, completionHandler: weatherCompleted)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startSpinner()
        if let locations = DatabaseService.locations,
            let location = locations.first(where: { $0.active }) {
            if (location.city != "Use GPS") {
                httpService.weatherByCity(location.city, completionHandler: weatherCompleted)
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
        cityLabel.text = ""
        weatherLabel.text = "";
        weatherImg.image = nil
        
    }
    
    func weatherCompleted(weather: WeatherDTO) {
        let weatherImgUrl: URL? = URL(string: WeatherDTO.iconUrl(weather.weather.last!.icon))
        weatherImg.loadURL(weatherImgUrl!, completeHandler: {() -> Void in
            self.cityLabel.text = weather.name
            self.weatherLabel.text = "\(weather.main.temp) \u{00B0}C - \(weather.weather.last!.weatherDescription!.capitalizingFirstLetter())"
            self.stopSpinner()
        })
    }

}

