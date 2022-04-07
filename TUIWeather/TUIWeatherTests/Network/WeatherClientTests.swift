
import XCTest
import Foundation
import PromiseKit
@testable import TUIWeather

private class TestManager : RequestManager {
    enum TestManagerError : Error {
        case configError
    }
    var getDataPromise : ((_ relativePath : String,_ query : [String]?) -> Promise<Data>)?
   
    override func getDataWithRelativePath(relativePath: String ,and query: [String]? = nil) -> Promise<Data> {
        guard let getDataPromise =  getDataPromise else {
            return Promise(error:TestManagerError.configError )
        }
        return getDataPromise(relativePath,query)
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
        let expectation = XCTestExpectation(description: "testThatItShouldAskNetworkManagerWithCorrectPath")
        networkManager.getDataPromise =  { relativePath ,_ in
            path = relativePath
            return Promise.value(Data())
        }
       
        _ = weatherClient.cityWeatherForecast(with: 1).done { _ in
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(path, "/data/2.5/forecast")
        
    }
    
    func testThatItShouldHandleSuccessCaseCorrectly() {
        networkManager.getDataPromise = { _ ,_ in
            return Promise.value(self.weatherInfoListData)
        }
        var weatherInfoList : WeatherInfoList!
        let expectation = self.expectation(description: "fetch weatherInfoList")
        _ = weatherClient.cityWeatherForecast(with: 1).done { infoList in
            weatherInfoList = infoList
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(weatherInfoList)

    }
    
    func testThatItShouldHandleErrorCaseCorrectly() {
        networkManager.getDataPromise = { _ ,_ in
            return Promise(error: ClientError.InvalidFormat(data: nil))
        }
        var weatherInfoList : WeatherInfoList!
        let expectation = self.expectation(description: "fetch weatherInfoList")
        _ = weatherClient.cityWeatherForecast(with: 1).done { infoList in
            weatherInfoList = infoList
            expectation.fulfill()
        }.catch { _ in
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 20.0)
        XCTAssertNil(weatherInfoList)
    }
  
    
}
