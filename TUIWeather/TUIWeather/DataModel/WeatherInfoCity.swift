import Foundation


/*
 
 {
     "id": 524901,
     "name": "Moscow",
     "coord": {
     "lat": 55.7522,
     "lon": 37.6156
     },
     "country": "none"
 }
 
 */
struct WeatherInfoCity : Codable,CustomStringConvertible {
    
    private enum CodingKeys : String,CodingKey {
        case identifier = "id"
        case name = "name"
        case country = "country"
       
    }
    var description: String {
        return "\(name) - \(country) [\(identifier)]"
    }
    let identifier : Int
    let name : String
    let country : String
  
}
