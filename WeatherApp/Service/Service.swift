//
//  Service.swift
//  MVC
//
//  Created by Vakas Zia on 16-10-2018.
//  Copyright © 2018 Vakas Zia. All rights reserved.
//

import Foundation

class Service: NSObject {
    static let shared = Service()

    func fetchWeatherData(weatherURL: String, completion: @escaping (WeatherData?, Error?)->()) {
        
        guard let url = URL(string: weatherURL) else { return }
//        self.serviceProtocol?.startedLoadingData()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
                print("Failed to load data :", error)
//                self.serviceProtocol?.didFinishLoadingData()
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherData, nil)
                }
            } catch let jsonError {
                    print("Failed to decode:", jsonError)
            }
            
        }.resume()
        
    }

}
