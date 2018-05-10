import Foundation

enum RequestManagerErrorType : Error {
    case InvalidURL(urlString : String)
}


protocol RequestManagerDelegate : class {
    func didStartURLTask(with requestManager: RequestManager,session : URLSession)
    func didFinishURLTask(with requestManager: RequestManager,session : URLSession)
}

class RequestManager : NSObject {
    weak var delegate : RequestManagerDelegate?  
    fileprivate let RequestManagerBaseURL = "https://api.openweathermap.org"

    fileprivate let ApplicationID = "ea7de0326863831395fe4487ac2fb3f1"
    public static let shared =  RequestManager()

    fileprivate lazy var session = URLSession(configuration: .default)

    
    public func getDataWithRelativePath(relativePath: String ,and query: [String]? = nil, completionBlock:@escaping ((_ data : Data?,_ error:Error?) -> Void)) {
        guard let url =  self.baseURL(withPath: relativePath,and: query) else {
            completionBlock(nil,RequestManagerErrorType.InvalidURL(urlString: relativePath))
            return
        }
        getDataWithURL(URL: url,completionBlock: completionBlock)
    }
}


// MARK : Private

extension RequestManager {
    fileprivate func getDataWithURL(URL: URL , completionBlock:@escaping ((_ data : Data?,_ error:Error?) -> Void)) {
        let task = session.dataTask(with: URL, completionHandler: { [weak self] (data, _, error) -> (Void) in
            
            if let strongSelf = self {
                strongSelf.delegate?.didFinishURLTask(with: strongSelf, session: strongSelf.session)
                
            }
            completionBlock(data,error)
        })
        task.resume()
        self.delegate?.didStartURLTask(with: self, session: session)
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
