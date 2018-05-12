
import XCTest
import UIKit
import Foundation
@testable import TUIWeather

fileprivate class MockCell : WeatherStatusCollectionViewCell {
    var configureCalled = false
    override func configure(with model: WeatherStatusTableViewModel) {
        configureCalled = true
    }
}

fileprivate class MockCollectionView : UICollectionView {
    var reloadDataBlock : (()->())?
    override func reloadData() {
        reloadDataBlock?()
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return MockCell(frame: .zero)
    }
}

class WeatherStatusDayViewTests: XCTestCase {
    
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
    
    var tableViewModels : [WeatherStatusTableViewModel]!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        let weatherInfoList = try! WeatherClient.jsonDecoder.decode(WeatherInfoList.self,from: weatherInfoListData)
        tableViewModels = viewModels(with: weatherInfoList).first!.models
    }
    
    func testThatItShouldReloadTableviewWhenSettingForecasts() {
        let dayView = WeatherStatusDayView(frame: .zero)
        let flowLayout = UICollectionViewFlowLayout()
        let mockCollectionView = MockCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        dayView.collectionView = mockCollectionView
        var reloadDataCalled = false
        mockCollectionView.reloadDataBlock = {
            reloadDataCalled = true
        }
        dayView.forecasts = tableViewModels
        XCTAssertTrue(reloadDataCalled)
    }

    func testThatItShouldReturnTheCorrectNumberOfRows() {
        let dayView = WeatherStatusDayView(frame: .zero)
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        dayView.collectionView = collectionView
        dayView.forecasts = tableViewModels
        
        let dataSource = dayView as UICollectionViewDataSource
        let count = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 8)
    }
    
    func testThatItConfiguresCellWithTheRightDataModel() {
        let dayView = WeatherStatusDayView(frame: .zero)
        let flowLayout = UICollectionViewFlowLayout()
        let mockCollectionView = MockCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        dayView.collectionView = mockCollectionView
        dayView.forecasts = tableViewModels
        let dataSource = dayView as UICollectionViewDataSource
        let cell = dataSource.collectionView(mockCollectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as! MockCell
        XCTAssertTrue(cell.configureCalled)
        
    }

}
