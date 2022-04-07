
import Foundation
import CoreData
import UIKit
import PromiseKit
enum ClientError : Error {
    case InvalidFormat(data : Data?)
}


class WeatherClient {
    enum APIPath : String {
        
        case cityWeatherPath = "/data/2.5/forecast"
        case image = "/img/w/"
        
    }
    
    lazy var networkManager  = RequestManager.shared
    
    func cityWeatherForecast(with identifier: Int,on queue : DispatchQueue = .main) -> Promise<WeatherInfoList> {
        return networkManager.getDataWithRelativePath(relativePath: APIPath.cityWeatherPath.rawValue,and:["id=\(identifier)"]).compactMap(on:queue) { data in
               return try JSONDecoder().decode(WeatherInfoList.self,from: data)
        }
    }
    
    func statusImage(with identifier: String,with queue : DispatchQueue = .main) -> Promise<UIImage> {
        let imagePath = "\(APIPath.image.rawValue)\(identifier).png"
        return networkManager.getDataWithRelativePath(relativePath: imagePath).compactMap(on:queue) { data in
            return UIImage(data:data)
        }

    }
}
