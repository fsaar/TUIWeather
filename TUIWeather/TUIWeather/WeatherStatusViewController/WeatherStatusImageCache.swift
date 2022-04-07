//
//  WeatherStatusImageCache.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit
import PromiseKit

class WeatherStatusImageCache {
    fileprivate var imageCache : [String : UIImage] = [:]
    lazy var weatherClient = WeatherClient()
    static let shared = WeatherStatusImageCache()
    
    func image(for identifier : String) -> Promise<UIImage> {
        guard let image = imageCache[identifier] else {
            return self.weatherClient.statusImage(with:identifier).then { [weak self] (image:UIImage) -> Promise<UIImage> in
                self?.imageCache[identifier] = image
                return Promise.value(image)
            }
        }
        return Promise.value(image)
    }
}
