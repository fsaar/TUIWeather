import Foundation
import PromiseKit

enum RequestManagerErrorType : Error {
    case InvalidURL(urlString : String)
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
    public func getDataWithRelativePath(relativePath: String ,and query: [String]? = nil, completionBlock:@escaping ((_ data : Data?,_ error:Error?) -> Void)) {
        guard let url =  self.baseURL(withPath: relativePath,and: query) else {
            completionBlock(nil,RequestManagerErrorType.InvalidURL(urlString: relativePath))
            return
        }
        getDataWithURL(URL: url,completionBlock: completionBlock)
    }
}

//
// MARK: Private
//
extension RequestManager {
    fileprivate func getDataWithURL(URL: URL , completionBlock:@escaping ((_ data : Data?,_ error:Error?) -> Void)) {
        firstly {
            session.dataTask(.promise, with: URL).validate()
            // ^^ we provide `.validate()` so that eg. 404s get converted to errors
        }.done { data,_ in
            completionBlock(data,nil)
        }.catch { error in
            completionBlock(nil,error)
        }
    }
    
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
