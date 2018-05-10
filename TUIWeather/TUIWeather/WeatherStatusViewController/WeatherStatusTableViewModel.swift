//
//  WeatherStatusTableViewModel.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit


struct WeatherStatusTableViewModel  {
    
    static let dateFormatter :  DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "en_GB")
        return dateFormatter
    }()
    static let timeFormatter :  DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone(identifier: "en_GB")
        return timeFormatter
    }()
    static let numberFormatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_GB")
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }()
    static let temperatureFormatter : MeasurementFormatter = {
        let temperatureFormatter = MeasurementFormatter()
        temperatureFormatter.locale = Locale(identifier: "en_GB")
        temperatureFormatter.numberFormatter = WeatherStatusTableViewModel.numberFormatter
        return temperatureFormatter
    }()
    
    let dateString  : String
    let timeString : String
    let temperature : String
    let date : Date
    init(with weatherInfo : WeatherInfo) {
        date = Date(timeIntervalSince1970: weatherInfo.timeStamp)
        dateString = WeatherStatusTableViewModel.dateFormatter.string(from: date)
        timeString = WeatherStatusTableViewModel.timeFormatter.string(from: date)
        let temp = Measurement(value: weatherInfo.temperature.current, unit: UnitTemperature.kelvin)
        temperature = WeatherStatusTableViewModel.temperatureFormatter.string(from: temp)
    }
    
}
