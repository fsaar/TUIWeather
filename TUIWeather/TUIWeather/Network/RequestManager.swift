import Foundation
import PromiseKit

enum RequestManagerErrorType : Error {
    case InvalidURL(urlString : String)
    case noData
}

class RequestManager : NSObject {
    fileprivate let RequestManagerBaseURL = "https://api.openweathermap.org"

    fileprivate let ApplicationID = "ab5e6e4f054d3f7585df774299f1a6ad"
    public static let shared =  RequestManager()

    lazy var session : URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: config)
        return session
    }()
    
    public func getDataWithRelativePath(relativePath: String ,and query: [String]? = nil) -> Promise<Data> {
        guard let url =  self.baseURL(withPath: relativePath,and: query) else {
            let error = RequestManagerErrorType.InvalidURL(urlString: relativePath)
            return Promise(error: error)
        }
        return Promise<Data> { promise in
            
            let task = session.dataTask(with: url, completionHandler: { data, _, error in
                if let data = data  {
                    promise.fulfill(data)
                }
                else if let error = error {
                    promise.reject(error)
                }
                else {
                    promise.reject(RequestManagerErrorType.noData)
                }
                
            })
            task.resume()
        }
//        return firstly {
//            session.dataTask(.promise, with: url).validate()
//        }.map { data,_ in
//           return data
//        }
    }
}

//
// MARK: Private
//
extension RequestManager {
    
    fileprivate func baseURL(withPath path: String,and query: [String]? = nil) -> URL? {
        let baseURL = NSURLComponents(string: RequestManagerBaseURL)
        if let baseURL = baseURL {
            let auth = "appid=\(ApplicationID)"
            let authQuery = (query ?? []) + [auth]
            baseURL.path = path
            baseURL.query = authQuery.joined(separator: "&")
            return baseURL.url
        }
        return nil
    }
    
}
