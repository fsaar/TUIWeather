//
//  WeatherStatusViewController
//  TUIWeather
//
//  Created by Frank Saar on 09/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit



class WeatherStatusViewController: UIViewController {
    enum SegueIdentifier : String {
        case weatherTableViewController = "WeatherStatusTableViewControllerSegue"
    }
    fileprivate let weather = WeatherClient()
    private var weatherStatusTableViewController : WeatherStatusTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.cityWeatherForecast(with: WeatherClient.CityIdentifier.London.rawValue) { [weak self] weatherInfoList,_ in
            self?.weatherStatusTableViewController?.weatherInfoList = weatherInfoList
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            return
        }
        switch segueIdentifier {
        case .weatherTableViewController:
            weatherStatusTableViewController = segue.destination as? WeatherStatusTableViewController
        }
    }
}

