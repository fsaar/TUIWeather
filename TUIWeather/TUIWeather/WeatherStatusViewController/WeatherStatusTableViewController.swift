//
//  WeatherStatusTableViewController.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit

typealias WeatherStatusTableViewControllerModel = (date: String, models : [WeatherStatusTableViewModel])

class WeatherStatusTableViewController: UITableViewController {
    @IBOutlet weak var statusMapView : WeatherStatusMapView!
    var weatherStatusDayList: [WeatherStatusTableViewControllerModel] = []
    var weatherInfoList : WeatherInfoList? = nil {
        didSet {
            statusMapView.city = weatherInfoList?.city
            weatherStatusDayList = viewModels(with: weatherInfoList)
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherStatusDayList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherStatusTableViewCell.self), for: indexPath)

        if let cell = cell as? WeatherStatusTableViewCell {
            let day = weatherStatusDayList[indexPath.row]
            cell.configure(with: day)
        }

        return cell
    }
}

fileprivate extension WeatherStatusTableViewController {
    func viewModels(with infoList : WeatherInfoList?) -> [WeatherStatusTableViewControllerModel] {
        guard let infoList = infoList else {
            return []
        }
        let viewModels = infoList.list.map { WeatherStatusTableViewModel(with: $0) }
        let groupdict = Dictionary(grouping: viewModels,by: { $0.dateString })
        let minDate = Date(timeIntervalSince1970: 0)
        let dateStringTuples = groupdict.map { return (dateString:$0,date:$1.first?.date ?? minDate,models:$1) }
        return dateStringTuples.sorted { $0.date < $1.date }.map { ($0.dateString,$0.models)}
    }
}
