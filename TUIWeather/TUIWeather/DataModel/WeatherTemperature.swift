import Foundation


/*
 
    {
         "temp": 261.45,
         "temp_min": 259.086,
         "temp_max": 261.45,
         "pressure": 1023.48,
         "sea_level": 1045.39,
         "grnd_level": 1023.48,
         "humidity": 79,
         "temp_kf": 2.37
     },
 
 */
struct WeatherTemperature : Decodable,CustomStringConvertible {
    
    private enum CodingKeys : String,CodingKey {
        case temperature = "temp"
        case temperature_min = "temp_min"
        case temperature_max = "temp_max"
       
    }
    var description: String {
        return "\(temperature) [\(temperature_min)-\(temperature_max)]"
    }
    let temperature : Float
    let temperature_min : Float
    let temperature_max : Float
}
