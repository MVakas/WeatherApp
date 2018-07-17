//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Vakas Zia on 16-10-2018.
//  Copyright © 2018 Vakas Zia. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    let icon: String
    let min_max: String
    let day: String
    let dateFormatter = DateFormatter()
    
    init(list: list) {
        icon = "http://openweathermap.org/img/w/\(list.weather[0].icon).png"
        let min = String(format: "%.1f", list.main.temp_min)
        let max = String(format: "%.1f", list.main.temp_max)
        min_max = "Min : \(min) | Max : \(max)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        day = (dateFormatter.date(from: list.dt_txt)?.dayNumberOfWeek())!
    }
}
