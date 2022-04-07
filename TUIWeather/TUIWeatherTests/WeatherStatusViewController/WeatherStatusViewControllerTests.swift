
import XCTest
import Foundation
import PromiseKit
@testable import TUIWeather


private class MockWeatherClient : WeatherClient {
    enum MockError : Error {
        case noError
    }
    var foreCastBlock : (() -> (WeatherInfoList?,Error?))?
    
    override func cityWeatherForecast(with identifier: Int,on queue : DispatchQueue = .main) -> Promise<WeatherInfoList> {
        
        let tuple = foreCastBlock?()
        if let value = tuple?.0 {
            return Promise.value(value)
        }
        else  if let error = tuple?.1 {
            return Promise(error: error)
        }
        return Promise(error: MockError.noError)
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
        weatherInfoList = try! JSONDecoder().decode(WeatherInfoList.self,from: weatherInfoListData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: String(describing:WeatherStatusViewController.self)) as? WeatherStatusViewController
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
        let expectation = expectation(description: "weatherinfo")
        weatherClient.foreCastBlock = {
            return (self.weatherInfoList,nil)
        }
        _ = controller.view

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(controller.weatherStatusTableViewController!.weatherInfoList)
    }
    
    func testShouldShowAlertViewWhenTapingUpdateLocation() {
        let delegate = UIApplication.shared.delegate! as! AppDelegate
        let window = delegate.window
        window?.rootViewController = controller
        _ = controller.view
        let button =  controller.updateLocationButton!
        let target = button.allTargets.first!
        let action = button.actions(forTarget: target,forControlEvent: .touchUpInside)?.first!
        let buttonSelector = NSSelectorFromString(action!)
        UIView.setAnimationsEnabled(false)
         controller.perform(buttonSelector,with: controller.updateLocationButton!)
      
        let presentedController = controller.presentedViewController
        XCTAssertTrue(presentedController is UIAlertController)
        UIView.setAnimationsEnabled(true)

        
        
    }
  
    
}
