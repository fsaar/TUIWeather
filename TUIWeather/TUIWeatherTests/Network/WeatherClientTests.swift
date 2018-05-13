
import XCTest
import Foundation
@testable import TUIWeather

private class TestManager : RequestManager {
    var getDataBlock : ((_ relativePath : String,_ query : [String]?,_ completionBlock : (_ data : Data?,_ error:Error?) -> Void) -> Void)?
    override func getDataWithRelativePath(relativePath: String ,and query: [String]? = nil, completionBlock:@escaping ((_ data : Data?,_ error:Error?) -> Void)) {
        getDataBlock?(relativePath,query,completionBlock)
    }
}

class WeatherClientTests: XCTestCase {
    
    var weatherInfoListData : Data!
    var weatherClient : WeatherClient!
    fileprivate var networkManager : TestManager!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        weatherInfoListData = NSData(contentsOfFile: path)! as Data
        networkManager = TestManager()
        weatherClient = WeatherClient()
        weatherClient.networkManager = networkManager
    }
    
    func testThatItShouldAskNetworkManagerWithCorrectPath() {
        var path = ""
        networkManager.getDataBlock = { relativePath ,_,_ in
            path = relativePath
        }
        weatherClient.cityWeatherForecast(with: 1) { infoList,error in
            
        }
        XCTAssertEqual(path, "/data/2.5/forecast")
        
    }
    
    func testThatItShouldHandleErrorCaseCorrectly() {
        networkManager.getDataBlock = { _ ,_,completionBlock in
            completionBlock(self.weatherInfoListData,nil)
        }
        var weatherInfoList : WeatherInfoList!
        let expectation = self.expectation(description: "fetch weatherInfoList")
        weatherClient.cityWeatherForecast(with: 1) { infoList,error in
            weatherInfoList = infoList
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(weatherInfoList)

    }
    
    func testThatItShouldHandleSuccessCaseCorrectly() {
        networkManager.getDataBlock = { _ ,_,completionBlock in
            completionBlock(nil,ClientError.InvalidFormat(data: nil))
        }
        var weatherInfoList : WeatherInfoList!
        let expectation = self.expectation(description: "fetch weatherInfoList")
        weatherClient.cityWeatherForecast(with: 1) { infoList,error in
            weatherInfoList = infoList
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(weatherInfoList)
    }
  
    
}
