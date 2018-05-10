
import Foundation
import CoreData

enum ClientError : Error {
    case InvalidFormat(data : Data?)
}


class WeatherClient {
    enum CityIdentifier : String {
        case London = "2643743"
        case Kudepsta = "498817"
    }
    static let jsonDecoder = JSONDecoder()
    
    lazy var networkManager  = RequestManager.shared
    
    func cityWeather(with identifier: String,
                                     with operationQueue : OperationQueue = OperationQueue.main,
                                     using completionBlock:@escaping ((WeatherInfoList?,_ error:Error?) -> ()))  {
        let cityWeatherPath = "/data/2.5/forecast"
        networkManager.getDataWithRelativePath(relativePath: cityWeatherPath,and:["id=\(identifier)"]) { data, error in
            guard let data = data else {
                operationQueue.addOperation {
                    completionBlock(nil,error)
                }
                return
            }
           
            let weatherInfoList = try? WeatherClient.jsonDecoder.decode(WeatherInfoList.self,from: data)
            
            operationQueue.addOperation {
                completionBlock(weatherInfoList,nil)
            }
        }
    }
    
    
   // http://openweathermap.org/img/w/10d.png
}

