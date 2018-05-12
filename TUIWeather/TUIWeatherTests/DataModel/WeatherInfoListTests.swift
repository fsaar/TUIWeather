
import XCTest
import Foundation
@testable import TUIWeather


class WeatherInfoListTests: XCTestCase {
    
   
    func testThatItShouldCorrectlyDecodeGivenData() {
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        let weatherInfoList = try! WeatherClient.jsonDecoder.decode(WeatherInfoList.self,from: weatherInfoListData)
        XCTAssertNotNil(weatherInfoList.city)
        XCTAssertTrue(weatherInfoList.list.count == 10)
    }

    func testThatItShouldNotThrowGivenInvalidData() {
        let path = Bundle(for:type(of: self)).path(forResource: "invalidWeatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        XCTAssertNoThrow({
            _ = try! WeatherClient.jsonDecoder.decode(WeatherInfoList.self,from: weatherInfoListData)
        })
    }
}
