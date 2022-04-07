
import XCTest
import Foundation

@testable import TUIWeather


class WeatherInfoTests: XCTestCase {
    
   
    func testThatItShouldCorrectlyDecodeGivenData() {
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfo", ofType: "json")!
        let weatherInfoData = NSData(contentsOfFile: path)! as Data
        let weatherInfo = try! JSONDecoder().decode(WeatherInfo.self,from: weatherInfoData)
        XCTAssertEqual(weatherInfo.timeStamp, 1526083200.0)
        XCTAssertEqual(weatherInfo.iconIdentifier, "10n")
        XCTAssertEqual(weatherInfo.temperature.current, 282.22000000000003)
        XCTAssertEqual(weatherInfo.temperature.min, 282.22000000000003)
        XCTAssertEqual(weatherInfo.temperature.max, 282.44200000000001)
    }

    func testThatItShouldNotThrowGivenInvalidData() {
        let path = Bundle(for:type(of: self)).path(forResource: "invalidWeatherInfo", ofType: "json")!
        let weatherInfoData = NSData(contentsOfFile: path)! as Data
        XCTAssertNoThrow({
            _ = try! JSONDecoder().decode(WeatherInfo.self,from: weatherInfoData)
        })
    }
}
