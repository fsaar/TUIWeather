
import XCTest
import Foundation
@testable import TUIWeather


class WeatherStatusTableViewModelTests: XCTestCase {
    
    var weatherInfo : WeatherInfo!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfo", ofType: "json")!
        let weatherInfoData = NSData(contentsOfFile: path)! as Data
        weatherInfo = try! JSONDecoder().decode(WeatherInfo.self,from: weatherInfoData)
    }
    
    func testThatItShouldSetupDataCorrectly() {
        let model = WeatherStatusTableViewModel(with: weatherInfo)
        
        XCTAssertEqual(model.dateString, "2018-05-12")
        XCTAssertEqual(model.timeString, "01:00")
        XCTAssertEqual(model.temperature, "9°C")
        XCTAssertEqual(model.iconIdentifier, "10n")
    }
  
    
}
