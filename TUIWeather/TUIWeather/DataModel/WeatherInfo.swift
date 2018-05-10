import Foundation


/*
 {
     "dt": 1485799200,
     "main": {
         "temp": 261.45,
         "temp_min": 259.086,
         "temp_max": 261.45,
         "pressure": 1023.48,
         "sea_level": 1045.39,
         "grnd_level": 1023.48,
         "humidity": 79,
         "temp_kf": 2.37
     },
     "weather": [{
         "id": 800,
         "main": "Clear",
         "description": "clear sky",
         "icon": "02n"
     }],
     "clouds": {
        "all": 8
     },
     "wind": {
         "speed": 4.77,
         "deg": 232.505
     },
     "snow": {},
     "sys": {
        "pod": "n"
     },
     "dt_txt": "2017-01-30 18:00:00"
 
 }
 */
struct WeatherInfo : Equatable,Decodable,CustomStringConvertible {
    
    private enum CodingKeys : String,CodingKey {
        case timeStamp = "dt"
        case temperatures = "main"
    }
    private enum WeatherTemperature : String,CodingKey {
        case temperature = "temp"
        case temperature_min = "temp_min"
        case temperature_max = "temp_max"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timeStamp = try values.decode(Double.self, forKey: .timeStamp)
        let temperatures = try values.nestedContainer(keyedBy: WeatherTemperature.self, forKey: .temperatures)
        let currentTemp = try temperatures.decode(Double.self, forKey: .temperature)
        let minTemp = try temperatures.decode(Double.self, forKey: .temperature_min)
        let maxTemp  = try temperatures.decode(Double.self, forKey: .temperature_max)
        temperature = (currentTemp,minTemp,maxTemp)
    }
    public static func ==(lhs: WeatherInfo,rhs: WeatherInfo) -> (Bool) {
        return lhs.timeStamp == rhs.timeStamp
    }
    
    public var description: String {
        return timeStamp.description
    }
    let timeStamp : Double
    let temperature : (current:Double,min: Double,max: Double)
}
