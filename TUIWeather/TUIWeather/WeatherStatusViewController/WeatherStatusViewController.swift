//
//  WeatherStatusViewController
//  TUIWeather
//
//  Created by Frank Saar on 09/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit



class WeatherStatusViewController: UIViewController {
    @IBOutlet weak var updateLocationButton : UIButton! {
        didSet {
            self.updateLocationButton.setTitle(NSLocalizedString("WeatherStatusViewController.ChangeLocation", comment: ""), for: .normal)
        }
    }
    enum SegueIdentifier : String {
        case weatherTableViewController = "WeatherStatusTableViewControllerSegue"
    }
    var currentCity : WeatherInfoCity? = nil {
        didSet {
            if let city = currentCity {
                self.title = city.name
                updateLocation(to: city)
            }
        }
    }
    let ukCities : [WeatherInfoCity] = {
        var cities : [WeatherInfoCity] = []
        if let path = Bundle.main.path(forResource: "ukcityList", ofType: "json"),let data = try? NSData(contentsOfFile: path) as Data {
            cities = ((try? JSONDecoder().decode([WeatherInfoCity].self,from: data)) ?? []).filter { $0.country == "GB" }
        }
        return cities
    }()
    
    fileprivate let weather = WeatherClient()
    private var weatherStatusTableViewController : WeatherStatusTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCity = ukCities.first
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
    
    @IBAction func updateLocationHandler() {
        let alertController = UIAlertController(title: NSLocalizedString("WeatherStatusViewController.ChangeLocation",comment:""), message: nil, preferredStyle: .actionSheet)
        for city in ukCities {
            let action = UIAlertAction(title: city.name, style: .default) { [weak self] _ in
                self?.currentCity = city
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title:NSLocalizedString("WeatherStatusViewController.Cancel",comment:""), style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

fileprivate extension WeatherStatusViewController {
    func updateLocation(to city: WeatherInfoCity) {
        weather.cityWeatherForecast(with: city.identifier) { [weak self] weatherInfoList,_ in
            self?.weatherStatusTableViewController?.weatherInfoList = weatherInfoList
        }
    }
}

