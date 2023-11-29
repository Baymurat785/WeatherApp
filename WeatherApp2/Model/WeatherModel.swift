//
//  WeatherModel.swift
//  WeatherApp2
//
//  Created by Baymurat Abdumuratov on 25/11/23.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    
    
    var conditonName: String {
        switch conditionId{
                            // here we can get image by the condition id of the weather
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
