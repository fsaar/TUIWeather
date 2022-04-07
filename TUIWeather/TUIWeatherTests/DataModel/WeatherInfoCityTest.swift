
import XCTest
import Foundation
@testable import TUIWeather


class WeatherInfoCityTests: XCTestCase {
    
   
    func testThatItShouldCorrectlyDecodeGivenData() {
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoCity", ofType: "json")!
        let weatherInfoCityData = NSData(contentsOfFile: path)! as Data
        let weatherInfoCity = try! JSONDecoder().decode(WeatherInfoCity.self,from: weatherInfoCityData)
        XCTAssertEqual(weatherInfoCity.country,"GB")
        XCTAssertEqual(weatherInfoCity.name,"Edinburgh (local)")
        XCTAssertEqual(weatherInfoCity.identifier,2650225)
        XCTAssertEqual(weatherInfoCity.latitude,55.952100000000002)
        XCTAssertEqual(weatherInfoCity.longitude,-3.1964999999999999)
    }

    func testThatItShouldNotThrowGivenInvalidData() {
        let path = Bundle(for:type(of: self)).path(forResource: "invalidWeatherInfoCity", ofType: "json")!
        let weatherInfoCityData = NSData(contentsOfFile: path)! as Data
        XCTAssertNoThrow({
            _ = try! JSONDecoder().decode(WeatherInfo.self,from: weatherInfoCityData)
        })
    }
}
