//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Vakas Zia on 16-10-2018.
//  Copyright © 2018 Vakas Zia. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let list: [list]
    let city: city
//    let weather: weather
}

struct list: Decodable {
    let main: main
    let weather: [weather]
    let dt_txt: String
    let clouds: clouds
    let wind: wind
}

struct main: Decodable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let sea_level: Float
    let grnd_level: Float
    let humidity: Float
    let temp_kf: Float
}

struct clouds: Decodable {
    let all: Float
}

struct wind: Decodable {
    let speed: Float
    let deg: Float
}

struct weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct city: Decodable {
    let name: String
    let coord: coord
}
struct coord: Decodable {
    let lat: Float
    let lon: Float
}
