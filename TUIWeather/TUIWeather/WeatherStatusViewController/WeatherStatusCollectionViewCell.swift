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
    @IBOutlet weak var time : UILabel!
    private var model : WeatherStatusTableViewModel?
    private lazy var weatherImageCache =  WeatherStatusImageCache.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusImage.image = nil
        temperature.text = nil
        time.text = nil
        model = nil
    }

    func configure(with model : WeatherStatusTableViewModel) {
        self.temperature.text = model.temperature
        self.time.text = model.timeString
        self.model = model
        let date = model.date
        weatherImageCache.image(for: model.iconIdentifier) { [weak self] image in
            if let currentDate = self?.model?.date, currentDate == date {
                self?.statusImage.image = image
            }

        }
    }
}
