//
//  WeatherData.swift
//  WeatherApp2
//
//  Created by Baymurat Abdumuratov on 23/11/23.
//

import Foundation

//We created this struct in order expand the shelf, it will keep API JSON code


struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double      //keep in mind that this temp must match the work in JSON data
}

struct Weather: Codable{
    let description: String
    let id: Int
    }

