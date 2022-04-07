
import XCTest
import Foundation
import PromiseKit

@testable import TUIWeather

private class MockWeatherClient : WeatherClient {
    
    var statusImageCalled = false
    
    override func statusImage(with identifier: String,with queue : DispatchQueue = .main) -> Promise<UIImage> {
        statusImageCalled = true
        return Promise.value(UIImage())

    }
}

class WeatherStatusImageCacheTests: XCTestCase {
    
    var imageCache : WeatherStatusImageCache!
    fileprivate var weatherClient : MockWeatherClient!
    override func setUp() {
        super.setUp()
        weatherClient = MockWeatherClient()
        imageCache = WeatherStatusImageCache.shared
        imageCache.weatherClient = weatherClient
    }
    
    func testThatItShouldAskWeatherClientForImageIfNotCached() {
        _ = imageCache.image(for: "123").done {_ in
        
        }
        XCTAssertTrue(weatherClient.statusImageCalled)
    }
    
    func testThatItShouldNotAskWeatherClientForImageIfImageCached() {
        let expectation = expectation(description: "Image Cache expectation")
        let expectation2 = XCTestExpectation.init(description: "Image Cache expectation")
        _ = imageCache.image(for: "256").done {_ in
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
        weatherClient.statusImageCalled = false
        _ = imageCache.image(for: "256").done  {_ in
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 20)
        XCTAssertFalse(weatherClient.statusImageCalled)
    }
    
    func testThatItShouldCallCompletionBlockIfImageNotCached() {
        var completionBlockCalled = false
        let expectation = expectation(description: "Image Cache expectation")
        _ = imageCache.image(for: "123").done  {_ in
            completionBlockCalled = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(completionBlockCalled)
    }
    
    func testThatItShouldCallCompletionBlockIfImageCached() {
        var completionBlockCalled = false
        let expectation = expectation(description: "Image Cache expectation")
        let expectation2 = XCTestExpectation.init(description: "Image Cache expectation")
        _ = imageCache.image(for: "256").done {_ in
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
        weatherClient.statusImageCalled = false
        _ = imageCache.image(for: "256").done {_ in
            completionBlockCalled = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 20)
        XCTAssertTrue(completionBlockCalled)
    }
  
    
}
