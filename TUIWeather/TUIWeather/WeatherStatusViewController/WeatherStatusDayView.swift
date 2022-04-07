import UIKit

class WeatherStatusDayView: UIView {
    
    @IBOutlet weak var collectionView : UICollectionView!
    var forecasts : [WeatherStatusTableViewModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDataSource

extension WeatherStatusDayView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.forecasts.count
        return count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WeatherStatusCollectionViewCell.self), for: indexPath)
        if let cell = cell as? WeatherStatusCollectionViewCell {
            let forecast = forecasts[indexPath.row]
            cell.configure(with: forecast)
        }
        return cell
    }

}
