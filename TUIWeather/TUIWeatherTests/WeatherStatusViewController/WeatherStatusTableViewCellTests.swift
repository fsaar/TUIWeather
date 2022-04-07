
import XCTest
import MapKit
import Foundation
@testable import TUIWeather



class WeatherStatusTableViewCellTests: XCTestCase {
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
    
    var tableViewControllerModel : WeatherStatusTableViewControllerModel!
    var cell : WeatherStatusTableViewCell!
    var dateLabel : UILabel!
    var dayView :  WeatherStatusDayView!
    var mockCollectionView : UICollectionView!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        let weatherInfoList = try! JSONDecoder().decode(WeatherInfoList.self,from: weatherInfoListData)
        tableViewControllerModel = viewModels(with: weatherInfoList).first!
        dateLabel = UILabel(frame: .zero)
        dayView = WeatherStatusDayView(frame: .zero)
        let flowLayout = UICollectionViewFlowLayout()
        mockCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        dayView.collectionView = mockCollectionView
        cell = WeatherStatusTableViewCell(frame: .zero)
        cell.dayView = dayView
        cell.dateLabel = dateLabel
    }
    
    func testThatItShouldSetDateLabel() {
        XCTAssertNil(dateLabel.text)
        cell.configure(with: tableViewControllerModel)
        XCTAssertNotNil(dateLabel.text)
    }
    
    func testThatItShouldPropagateModelToDayView() {
        XCTAssertEqual(dayView.forecasts.count, 0)
        cell.configure(with: tableViewControllerModel)
        XCTAssertEqual(dayView.forecasts.count, 8)
    }
    
    func testThatItShouldResetDateLabelInPrepareForReuse() {
        cell.configure(with: tableViewControllerModel)
        XCTAssertNotNil(dateLabel.text)
        cell.prepareForReuse()
        XCTAssertNil(dateLabel.text)
    }

}
