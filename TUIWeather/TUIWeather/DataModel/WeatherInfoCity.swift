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
struct WeatherInfoCity : Decodable,CustomStringConvertible {
    
    private enum CodingKeys : String,CodingKey {
        case identifier = "id"
        case name = "name"
        case country = "country"
        case coordinates = "coord"
    }
    private enum WeatherInfoCityCoordinates : String,CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    var description: String {
        return "\(name) - \(country) [\(identifier)]"
    }
    let identifier : Int
    let name : String
    let country : String
    let latitude : Double
    let longitude : Double
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(Int.self, forKey: .identifier)
        name = try values.decode(String.self, forKey: .name)
        country = try values.decode(String.self, forKey: .country)
        
        let coordinates = try values.nestedContainer(keyedBy: WeatherInfoCityCoordinates.self, forKey: .coordinates)
        latitude = try coordinates.decode(Double.self, forKey: .latitude)
        longitude = try coordinates.decode(Double.self, forKey: .longitude)
    }
  
}
