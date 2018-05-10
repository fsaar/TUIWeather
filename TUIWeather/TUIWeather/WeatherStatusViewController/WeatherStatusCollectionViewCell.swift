//
//  WeatherStatusCollectionViewCell.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit

class WeatherStatusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var statusImage : UIImageView!
    @IBOutlet weak var temperature : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusImage.image = nil
        temperature.text = nil
    }

    func configure(with model : WeatherStatusTableViewModel) {
        self.temperature.text = model.temperature
    }
}
