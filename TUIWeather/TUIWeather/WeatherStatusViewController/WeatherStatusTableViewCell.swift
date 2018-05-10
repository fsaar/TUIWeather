//
//  WeatherStatusTableViewCell.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit

class WeatherStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var temperature : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    func configure(with text : String) {
        self.temperature.text = text
    }
}
