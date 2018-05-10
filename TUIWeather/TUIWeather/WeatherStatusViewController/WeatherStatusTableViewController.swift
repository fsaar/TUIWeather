//
//  WeatherStatusTableViewController.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit

class WeatherStatusTableViewController: UITableViewController {

    var weatherInfoList : WeatherInfoList? = nil {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherInfoList?.list.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherStatusTableViewCell.self), for: indexPath)

        if let cell = cell as? WeatherStatusTableViewCell {
            let weatherInfo = weatherInfoList?.list[indexPath.row]
            cell.configure(with: String(weatherInfo?.temperature ?? 0))
        }

        return cell
    }
}
