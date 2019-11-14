//
//  WeatherData.swift
//  SimpleWeather
//
//  Created by jungwooram on 2019-11-13.
//  Copyright © 2019 jungwooram. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    
}
struct Weather: Decodable {
    let description: String
    let id:Int
    
}
