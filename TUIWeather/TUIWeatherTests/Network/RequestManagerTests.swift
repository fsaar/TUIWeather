
import XCTest
import Foundation
import PromiseKit
@testable import TUIWeather

class TestURLSession : URLSession {
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
        let expectation = XCTestExpectation(description: "testThatItShouldUseCorrectRelativePath")
        var hasCorrectRelativePath = false
     
        testSession.dataTask = { url,_ in
            hasCorrectRelativePath = url.absoluteString.hasPrefix("https://api.openweathermap.org/test")
            return nil
        }
        
        manager.getDataWithRelativePath(relativePath: "/test",and: ["query"]).done { _ in
            expectation.fulfill()
        }.catch { error in
            expectation.fulfill()
        }
                                            
        wait(for: [expectation], timeout: 10)
        XCTAssert(hasCorrectRelativePath == true)
    }
    
    func testThatItShouldUseCorrectQuery() {
        let expectation = XCTestExpectation(description: "testThatItShouldUseCorrectQuery")
        var hasCorrectQuery = false
        testSession.dataTask = { url,_ in
            hasCorrectQuery = url.absoluteString.hasPrefix("https://api.openweathermap.org/test?query")
            return nil
        }
        _ = manager.getDataWithRelativePath(relativePath: "/test",and: ["query"]).done { _ in
            expectation.fulfill()
        }.catch { error in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssert(hasCorrectQuery == true)
    }
    
    func testThatItShouldCreateDataTask() {
        let expectation = XCTestExpectation(description: "testThatItShouldUseCorrectQuery")
        var taskCalled = false
        testSession.dataTask = { _,_ in
            taskCalled = true
            return nil
        }
        _ = manager.getDataWithRelativePath(relativePath: "/test").done { _ in
            expectation.fulfill()
        }.catch { error in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssert(taskCalled == true) 
    }
    
    func testThatItShouldAppendAppID() {
        let expectation = XCTestExpectation(description: "testThatItShouldUseCorrectQuery")
        var hasAppID = false
        testSession.dataTask = { url,_ in
            let urlString = url.absoluteString
            hasAppID = urlString.range(of: "appid=") != nil
            return nil
        }
        _ = manager.getDataWithRelativePath(relativePath: "/test").done { _ in
            expectation.fulfill()
        }.catch { error in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssert(hasAppID == true)
    }
    
    func testThatItShouldCallCompletionBlock() {
        let expectation = XCTestExpectation(description: "testThatItShouldCallCompletionBlock")
        var completionBlockCalled = false
        testSession.dataTask = { url,block in
            block(nil,nil,nil)
            return nil
        }
        _ = manager.getDataWithRelativePath(relativePath: "/test").done { _ in
            completionBlockCalled = true
            expectation.fulfill()
        }.catch { error in
            completionBlockCalled = true
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssert(completionBlockCalled == true)
    }
    
}
