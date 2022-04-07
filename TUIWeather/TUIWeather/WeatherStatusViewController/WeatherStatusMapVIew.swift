import UIKit
import MapKit

class WeatherStatusMapView: UIView {
    
    @IBOutlet weak var mapView : MKMapView!
    
    var city : WeatherInfoCity? = nil {
        didSet {
            guard let city = city else {
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
            guard CLLocationCoordinate2DIsValid(coordinate) else {
                return
            }
            let defaultCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1/2, longitudeDelta: 1/2)
            let region = MKCoordinateRegion(center: coordinate, span: defaultCoordinateSpan)
            self.mapView.setRegion(region, animated: true)
        }
    }
}
