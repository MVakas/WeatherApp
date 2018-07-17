//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Vakas Zia on 16-10-2018.
//  Copyright © 2018 Vakas Zia. All rights reserved.
//

import Foundation

extension UIImageView {
    func imageFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func imageFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        imageFrom(url: url, contentMode: mode)
    }
}

extension Date {
    func dayNumberOfWeek() -> String? {
        switch Calendar.current.dateComponents([.weekday], from: self).weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return nil
        }
    }
}

class WeatherViewModel {
    
    let city: String
    let lat_long: String
    let currentTemperature: String
    let min_max: String
    let day: String
    let dateFormatter = DateFormatter()
    let iconURL: String
    let list: [list]
    let weatherInfo: String
    let windRainPercentage: String
    
    init(weather: WeatherData) {
        city = weather.city.name
        let lat = String(format: "%.2f", weather.city.coord.lat)
        let long = String(format: "%.2f", weather.city.coord.lon)
        let temp = String(format: "%.1f", weather.list[0].main.temp)
        lat_long = "\(lat), \(long)"
        currentTemperature = "\(temp) °F"
        let min = String(format: "%.1f", weather.list[0].main.temp_min)
        let max = String(format: "%.1f", weather.list[0].main.temp_max)
        min_max = "Min : \(min) | Max : \(max)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        day = (dateFormatter.date(from: weather.list[0].dt_txt)?.dayNumberOfWeek())!
        iconURL = "http://openweathermap.org/img/w/\(weather.list[0].weather[0].icon).png"
        list = weather.list
        weatherInfo = weather.list[0].weather[0].main + ", " + weather.list[0].weather[0].description
        windRainPercentage = "Wind: \(weather.list[0].wind.speed) | Clouds: \(weather.list[0].clouds.all)%"
    }

}


