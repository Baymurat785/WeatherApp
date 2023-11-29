//
//  WeatherManager.swift
//  WeatherApp2
//
//  Created by Baymurat Abdumuratov on 22/11/23.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=06ad320a961519b9776789ff97cc952e&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchData(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchData(lat: CLLocationDegrees, lon: CLLocationDegrees){ // use this typealias for Double, but my results are the same in the both types.
        
        
        
        
        //you will see this calling this func in WeatherViewController in location manager section
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Create a URL
        
        if let url = URL(string: urlString){
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return //means here to execute thsi function because it is pointless to carry on
                }
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather) // here is the delegate of WeatherManagerDelegate. 
                    }
                }
                
            }
            //4. Start the task
            task.resume()
        }
        
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
       let decoder = JSONDecoder()
        do {
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData) //this will decode the data
            let id       = decodedData.weather[0].id
            let temp     = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}



//When your app talks with web server, it is networking

