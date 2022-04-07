
import XCTest
import Foundation
@testable import TUIWeather


fileprivate class MockCell : WeatherStatusTableViewCell {
    var configureCalled = false
    override func configure(with model : WeatherStatusTableViewControllerModel) {
        configureCalled = true
    }
}

fileprivate class MockTableView : UITableView {
    var reloadDataBlock : (()->())?
    override func reloadData() {
        reloadDataBlock?()
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> WeatherStatusTableViewCell {
        return MockCell(frame: .zero)
    }
}

class WeatherStatusTableViewControllerTests: XCTestCase {
    
    
    var weatherInfoList : WeatherInfoList!
    var controller : WeatherStatusTableViewController!
    override func setUp() {
        super.setUp()
        let path = Bundle(for:type(of: self)).path(forResource: "weatherInfoList", ofType: "json")!
        let weatherInfoListData = NSData(contentsOfFile: path)! as Data
        weatherInfoList = try! JSONDecoder().decode(WeatherInfoList.self,from: weatherInfoListData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: String(describing:WeatherStatusTableViewController.self)) as? WeatherStatusTableViewController
        _ = controller.view
        
    }
    
    func testThatItShouldReloadTableViewWhenSettingWeatherInfoList() {
        let mockTableView = MockTableView(frame: .zero)
        var dataReloaded = false
        mockTableView.reloadDataBlock = {
            dataReloaded = true
        }
        controller.tableView = mockTableView
        controller.weatherInfoList = weatherInfoList
        XCTAssertTrue(dataReloaded)
    }
    
    func testThatItShoudlReturnTheCorrectNumberOfRows() {
        controller.weatherInfoList = weatherInfoList
        let dataSource = controller as UITableViewDataSource
        let count = dataSource.tableView(controller.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(count, 2)
    }
    
    func testThatItShouldCallCellsConfigureMethod() {
        let mockTableView = MockTableView(frame: .zero)
        controller.tableView = mockTableView
        controller.weatherInfoList = weatherInfoList
        let dataSource = controller as UITableViewDataSource
        let cell = dataSource.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! MockCell
        XCTAssertTrue(cell.configureCalled)
    }
    
    func testThatRowShouldBeSortedByTime() {
         controller.weatherInfoList = weatherInfoList
        for weatherStatusDayList in controller.weatherStatusDayList {
            let model = weatherStatusDayList.models
            let dayListDates = model.map { $0.date }
            let sortedDayListDates = dayListDates.sorted (by:<)
            XCTAssertEqual(dayListDates, sortedDayListDates)
        }
    }
    
    func testThatRowShouldHaveTimeForSameDay() {
        controller.weatherInfoList = weatherInfoList
        for weatherStatusDayList in controller.weatherStatusDayList {
            let model = weatherStatusDayList.models
            let dayListDates = Set(model.map { $0.dateString })
            XCTAssertEqual(dayListDates.count, 1)
        }
    }
    
    func testThatRowsShouldSortedByDate() {
        controller.weatherInfoList = weatherInfoList
        let firstRowDates = controller.weatherStatusDayList.reduce([]) {
            sum,dayList in
            let date = dayList.models.first!.date
            return sum + [date]
        } as! [Date]
        let sortedFirstRowDates = firstRowDates.sorted(by: <)
        XCTAssertEqual(firstRowDates, sortedFirstRowDates)
    }
    
    
  
    
}
