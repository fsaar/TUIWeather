//
//  WeatherStatusTableViewCell.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit

class WeatherStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var dayView : WeatherStatusDayView!
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
    }

    func configure(with model : WeatherStatusTableViewControllerModel) {
        self.dateLabel.text = model.date
        self.dayView.forecasts = model.models
    }
}
