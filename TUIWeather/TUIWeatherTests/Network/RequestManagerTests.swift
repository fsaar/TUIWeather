
import XCTest
import Foundation
@testable import TUIWeather

private class TestURLSession : URLSession {
    var dataTask : ((_ url : URL,_ completionHandler: (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask?)?
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        return dataTask?(url,completionHandler) ?? URLSession(configuration: .default).dataTask(with: url,completionHandler:completionHandler)
    }
}

class RequestManagerTests: XCTestCase {
    var manager : RequestManager!
    fileprivate var testSession : TestURLSession!
    override func setUp() {
        super.setUp()
        manager = RequestManager()
        testSession = TestURLSession()
        manager.session = testSession
    }
    
    
    func testThatItShouldUseCorrectRelativePath() {
        
        var hasCorrectRelativePath = false
        testSession.dataTask = { url,_ in
            hasCorrectRelativePath = url.absoluteString.hasPrefix("https://api.openweathermap.org/test")
            return nil
        }
        manager.getDataWithRelativePath(relativePath: "/test",and: ["query"]) { _,_ in
            
        }
        XCTAssert(hasCorrectRelativePath == true)
    }
    
    func testThatItShouldUseCorrectQuery() {
        var hasCorrectQuery = false
        testSession.dataTask = { url,_ in
            hasCorrectQuery = url.absoluteString.hasPrefix("https://api.openweathermap.org/test?query")
            return nil
        }
        manager.getDataWithRelativePath(relativePath: "/test",and: ["query"]) { _,_ in
            
        }
        XCTAssert(hasCorrectQuery == true)
    }
    
    func testThatItShouldCreateDataTask() {
        var taskCalled = false
        testSession.dataTask = { _,_ in
            taskCalled = true
            return nil
        }
        manager.getDataWithRelativePath(relativePath: "/test") { _,_ in
            
        }
        XCTAssert(taskCalled == true) 
    }
    
    func testThatItShouldAppendAppID() {
        var hasAppID = false
        testSession.dataTask = { url,_ in
            let urlString = url.absoluteString
            hasAppID = urlString.range(of: "appid=") != nil
            return nil
        }
        manager.getDataWithRelativePath(relativePath: "/test") { _,_ in
            
        }
        XCTAssert(hasAppID == true)
    }
    
    func testThatItShouldCallCompletionBlock() {
        var completionBlockCalled = false
        testSession.dataTask = { url,block in
            block(nil,nil,nil)
            return nil
        }
        manager.getDataWithRelativePath(relativePath: "/test") { _,_ in
            completionBlockCalled = true
        }
        XCTAssert(completionBlockCalled == true)
    }
    
}
