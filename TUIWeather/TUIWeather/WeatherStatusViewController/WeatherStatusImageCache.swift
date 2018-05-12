//
//  WeatherStatusImageCache.swift
//  TUIWeather
//
//  Created by Frank Saar on 10/05/2018.
//  Copyright © 2018 tui. All rights reserved.
//

import UIKit

class WeatherStatusImageCache {
    fileprivate var imageCache : [String : UIImage] = [:]
    lazy var weatherClient = WeatherClient()
    static let shared = WeatherStatusImageCache()
    
    func image(for identifier : String, using completionBlock : @escaping (_ image : UIImage?) -> Void) {
        if let image = imageCache[identifier] {
            completionBlock(image)
        }
        else {
            self.weatherClient.statusImage(with:identifier) { [weak self] image,_ in
                self?.imageCache[identifier] = image
                completionBlock(image)
            }
        }
    }
}
