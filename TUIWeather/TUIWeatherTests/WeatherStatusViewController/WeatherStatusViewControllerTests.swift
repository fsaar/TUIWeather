
import XCTest
import Foundation
@testable import TUIWeather


private class MockWeatherClient : WeatherClient {
    
    var foreCastBlock : (() -> (WeatherInfoList?,Error?))?
    override func cityWeatherForecast(with identifier: Int,
                                      with operationQueue : OperationQueue = OperationQueue.main,
                                      using completionBlock:@escaping ((WeatherInfoList?,_ error:Error?) -> ()))   {
        let tuple = foreCastBlock?()
        if let tuple = tuple {
            completionBlock(tuple.0,tuple.1)
        }
        else {
            completionBlock(nil,nil)
        }
        
    }
}


class WeatherStatusViewControllerTests: XCTestCase {
    
    fileprivate var weatherClient : MockWeatherClient!
    var weatherInfoList : WeatherInfoList!
    var controller : WeatherStatusViewController!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        weatherInfoList = try! WeatherClient.jsonDecoder.decode(WeatherInfoList.self,from: weatherInfoListData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: String(describing:WeatherStatusViewController.self)) as! WeatherStatusViewController
        weatherClient = MockWeatherClient()
        controller.weatherClient = weatherClient
        
    }
    
    func testThatItShouldSetupCurrentCity() {
        _ = controller.view
        XCTAssertNotNil(controller.currentCity)
    }
    
    func testThatItShouldGetForecastforCurrentCity() {
        var foreCastBlockCalled = false
        weatherClient.foreCastBlock = {
            foreCastBlockCalled = true
            return (nil,nil)
        }
        _ = controller.view
        XCTAssertTrue(foreCastBlockCalled)
    }
    
    func testThatItShouldInitialiseTableViewControllerWithCity() {
        weatherClient.foreCastBlock = {
            return (self.weatherInfoList,nil)
        }
        _ = controller.view
        XCTAssertNotNil(controller.weatherStatusTableViewController!.weatherInfoList)
    }
    
  
    
}
