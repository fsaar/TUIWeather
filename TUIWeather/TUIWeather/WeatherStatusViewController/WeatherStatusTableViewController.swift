//
//  WeatherStatusTableViewController.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit



class WeatherStatusTableViewController: UITableViewController {
    var weatherStatusDayList: [(date: String, models : [WeatherStatusTableViewModel])] = []
    var weatherInfoList : WeatherInfoList? = nil {
        didSet {
            let viewModels = (weatherInfoList?.list ?? []).map { WeatherStatusTableViewModel(with: $0) }
            let groupdict = Dictionary(grouping: viewModels,by: { $0.dateString })
            let dateStringTuples = groupdict.map { return (dateString:$0,date:$1.first?.date ?? Date(timeIntervalSince1970: 0),models:$1) }
            weatherStatusDayList = dateStringTuples.sorted { $0.date < $1.date }.map { ($0.dateString,$0.models)}
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherStatusDayList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherStatusTableViewCell.self), for: indexPath)

        if let cell = cell as? WeatherStatusTableViewCell {
            let day = weatherStatusDayList[indexPath.row]
            cell.configure(with: day.date)
        }

        return cell
    }
}
