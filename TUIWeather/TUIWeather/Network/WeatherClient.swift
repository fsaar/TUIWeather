
import Foundation
import CoreData
import UIKit
enum ClientError : Error {
    case InvalidFormat(data : Data?)
}


class WeatherClient {
    
    static let jsonDecoder = JSONDecoder()
    
    lazy var networkManager  = RequestManager.shared
    
    func cityWeatherForecast(with identifier: Int,
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
    
    func statusImage(with identifier: String,
                             with operationQueue : OperationQueue = OperationQueue.main,
                             using completionBlock:@escaping ((_ image:UIImage?,_ error:Error?) -> ()))  {
        let imagePath = "/img/w/\(identifier).png"
        networkManager.getDataWithRelativePath(relativePath: imagePath) { data, error in
            guard let data = data else {
                operationQueue.addOperation {
                    completionBlock(nil,error)
                }
                return
            }
            let image = UIImage(data:data)
            operationQueue.addOperation {
                completionBlock(image,nil)
            }
        }
    }
}
