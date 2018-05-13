
import XCTest
import Foundation
@testable import TUIWeather

private class MockWeatherClient : WeatherClient {
    
    var statusImageCalled = false
    override func statusImage(with identifier: String,
                     with operationQueue : OperationQueue = OperationQueue.main,
                     using completionBlock:@escaping ((_ image:UIImage?,_ error:Error?) -> ()))  {
        statusImageCalled = true
        completionBlock(UIImage(),nil)
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
        imageCache.image(for: "123") {_ in
        
        }
        XCTAssertTrue(weatherClient.statusImageCalled)
    }
    
    func testThatItShouldNotAskWeatherClientForImageIfImageCached() {
        imageCache.image(for: "256") {_ in
            
        }
        weatherClient.statusImageCalled = false
        imageCache.image(for: "256") {_ in
            
        }
        XCTAssertFalse(weatherClient.statusImageCalled)
    }
    
    func testThatItShouldCallCompletionBlockIfImageNotCached() {
        var completionBlockCalled = false
        imageCache.image(for: "123") {_ in
            completionBlockCalled = true
        }
        XCTAssertTrue(completionBlockCalled)
    }
    
    func testThatItShouldCallCompletionBlockIfImageCached() {
        var completionBlockCalled = false
        
        imageCache.image(for: "256") {_ in
            
        }
        weatherClient.statusImageCalled = false
        imageCache.image(for: "256") {_ in
            completionBlockCalled = true
        }
        XCTAssertTrue(completionBlockCalled)
    }
  
    
}
