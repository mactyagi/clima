//
//  weatherData.swift
//  Clima
//
//  Created by manukant Tyagi on 28/02/21.

//

import Foundation
struct WeatherData : Codable {
    let name : String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable {
   var temp: Double
}
struct Weather : Codable{
    var description: String
    var id : Int
}
