//
//  ViewController.swift
//  TUIWeather
//
//  Created by Frank Saar on 09/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    fileprivate let weather = WeatherClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.cityWeather(with: WeatherClient.CityIdentifier.Kudepsta.rawValue) { _,_ in
            
        }
    }

    


}

