//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Vakas Zia on 16-10-2018.
//  Copyright © 2018 Vakas Zia. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherViewModel() {
        
        let weatherViewModel = WeatherViewModel(weather: WeatherData(list: [list(main: main(temp: 80, temp_min: 80, temp_max: 90, pressure: 10, sea_level: 20, grnd_level: 10, humidity: 70, temp_kf: 90), weather: [weather(id: 0, main: "clear", description: "clear", icon: "10d")], dt_txt: "2018-07-17 21:00:00", clouds: clouds(all: 80), wind: wind(speed: 12, deg: 70))], city: city(name: "Islamabad", coord: coord(lat: 33, lon: 73))))
        
        // check city with ViewModel
        XCTAssertEqual("Islamabad", weatherViewModel.city)
        // check weather the date in the ViewModel is equal to the day
        XCTAssertEqual("Tuesday", weatherViewModel.day)
    }
    
}
