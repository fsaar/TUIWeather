
import XCTest
import MapKit
import Foundation
@testable import TUIWeather

class MockImageCache : WeatherStatusImageCache {
    var fetchImageCalled = false
    override func image(for identifier : String, using completionBlock : @escaping (_ image : UIImage?) -> Void) {
        fetchImageCalled = true
    }
}

class WeatherStatusCollectionViewCellTests: XCTestCase {
    var city : WeatherInfoCity!
    var invalidCity : WeatherInfoCity!
    fileprivate func viewModels(with infoList : WeatherInfoList?) -> [WeatherStatusTableViewControllerModel] {
        guard let infoList = infoList else {
            return []
        }
        let viewModels = infoList.list.map { WeatherStatusTableViewModel(with: $0) }
        let groupdict = Dictionary(grouping: viewModels,by: { $0.dateString })
        let minDate = Date(timeIntervalSince1970: 0)
        let dateStringTuples = groupdict.map { return (dateString:$0,date:$1.first?.date ?? minDate,models:$1) }
        return dateStringTuples.sorted { $0.date < $1.date }.map { ($0.dateString,$0.models)}
    }
    
    var tableViewModel : WeatherStatusTableViewModel!
    var cell : WeatherStatusCollectionViewCell!
    var temperatureLabel : UILabel!
    var timeLabel : UILabel!
    var imageView : UIImageView!
    var imageCache : MockImageCache!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        let weatherInfoList = try! WeatherClient.jsonDecoder.decode(WeatherInfoList.self,from: weatherInfoListData)
        
        tableViewModel = viewModels(with: weatherInfoList).first!.models.first!
        temperatureLabel = UILabel(frame: .zero)
        timeLabel = UILabel(frame: .zero)
        imageView = UIImageView(frame: .zero)
        imageCache = MockImageCache()
        cell = WeatherStatusCollectionViewCell(frame: .zero)
        cell.temperature = temperatureLabel
        cell.statusImage = imageView
        cell.weatherImageCache = imageCache
        cell.time = timeLabel
    }
    
    func testThatItShouldSetTemperatureCorrectly() {
        cell.configure(with: tableViewModel)
        XCTAssertFalse(temperatureLabel.text!.isEmpty)
    }
    
    func testThatItShouldSetTimeCorrectly() {
        cell.configure(with: tableViewModel)
        XCTAssertFalse(timeLabel.text!.isEmpty)

    }
    
    func testThatItShouldResetLabelsInPrepareForReuse() {
        cell.configure(with: tableViewModel)
        cell.prepareForReuse()
        XCTAssertNil(timeLabel.text)
        XCTAssertNil(temperatureLabel.text)
    }
    
    func testThatItShouldFetchImage() {
        cell.configure(with: tableViewModel)
        XCTAssertTrue(imageCache.fetchImageCalled)
    }

}
