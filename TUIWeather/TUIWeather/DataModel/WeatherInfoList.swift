import Foundation


/*
 {
     "cod": "200",
     "message": 0.0036,
     "cnt": 40,
     "list": []
     "city": {}
  }
*/

struct WeatherInfoList : Decodable {
    
    private enum CodingKeys : String,CodingKey {
        case list
        case city 
    }
   
    let city : WeatherInfoCity
    let list : [WeatherInfo]
}

