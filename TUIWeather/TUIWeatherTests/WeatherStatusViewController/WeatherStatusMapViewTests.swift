
import XCTest
import MapKit
import Foundation
@testable import TUIWeather


fileprivate class TestMapView : MKMapView {
    var setRegionBlock : (()->())?
    override func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        setRegionBlock?()
    }
    
}

class WeatherStatusMapViewTests: XCTestCase {
    
    var city : WeatherInfoCity!
    var invalidCity : WeatherInfoCity!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoCity", ofType: "json")!
        let weatherInfoCityData = NSData(contentsOfFile: path)! as Data
        city = try! WeatherClient.jsonDecoder.decode(WeatherInfoCity.self,from: weatherInfoCityData)
        let invalidPath = Bundle(for:type(of: self)).path(forResource: "invalidWeatherInfoCityWithInvalidCoords", ofType: "json")!
        let invalidWeatherInfoCityData = NSData(contentsOfFile: invalidPath)! as Data
        invalidCity = try! WeatherClient.jsonDecoder.decode(WeatherInfoCity.self,from: invalidWeatherInfoCityData)
    }
    
    func testThatItShouldSetACitysCoordinate() {
        let statusMapView = WeatherStatusMapView(frame: .zero)
        let mapView = TestMapView(frame: .zero)
        var regionBlockCalled = false
        mapView.setRegionBlock = {
            regionBlockCalled = true
        }
        statusMapView.mapView = mapView
        statusMapView.city = city
        XCTAssertTrue(regionBlockCalled)
    }

    func testThatItShouldNotPropagateANilCity() {
        let statusMapView = WeatherStatusMapView(frame: .zero)
        let mapView = TestMapView(frame: .zero)
        var regionBlockCalled = false
        mapView.setRegionBlock = {
            regionBlockCalled = true
        }
        statusMapView.mapView = mapView
        statusMapView.city = nil
        XCTAssertFalse(regionBlockCalled)
    }
    
    func testThatItShouldNotPropagateACityWithAnInvalidCoordinate() {
        let statusMapView = WeatherStatusMapView(frame: .zero)
        let mapView = TestMapView(frame: .zero)
        var regionBlockCalled = false
        mapView.setRegionBlock = {
            regionBlockCalled = true
        }
        statusMapView.mapView = mapView
        statusMapView.city = invalidCity
        XCTAssertFalse(regionBlockCalled)
    }

}
