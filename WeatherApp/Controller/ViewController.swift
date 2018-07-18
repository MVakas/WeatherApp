//
//  ViewController.swift
//  WeatherApp
//
//  Created by Vakas Zia on 16-10-2018.
//  Copyright © 2018 Vakas Zia. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftLocation

class ViewController: UIViewController, ABCGooglePlacesSearchViewControllerDelegate {
    
    var weatherViewModel: WeatherViewModel?
    let activityIndicator = UIActivityIndicatorView()
    var fiveDayForecast = [list]()

    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var formattedAddressLabel: UILabel!
    @IBOutlet weak var cityNameTextLabel: UILabel!
    @IBOutlet weak var coordinatesTextLabel: UILabel!
    @IBOutlet weak var weatherDataTableView: UITableView!
    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var mainWeatherInfoLabel: UILabel!
    @IBOutlet weak var windRainPercentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Locator.requestAuthorizationIfNeeded()
        
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        
        self.weatherDataTableView.delegate = self
        self.weatherDataTableView.dataSource = self
        
        self.findCurrentLocation()

    }
    override func viewDidLayoutSubviews() {
        activityIndicator.center = currentLocationButton.center
        activityIndicator.bounds = currentLocationButton.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func fetchWeatherData(lat: Float, lon: Float) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Service.shared.fetchWeatherData(weatherURL: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=imperial&APPID=54b4cec1b23e603de7e683c0a3a63f5c") { data, error in
            if let error = error {
                self.currentLocationButton.isHidden = false
                self.activityIndicator.stopAnimating()
                print("Unable to load data: ", error.localizedDescription)
                return
            }
            
            self.currentLocationButton.isHidden = false
            self.activityIndicator.stopAnimating()
            MBProgressHUD.hide(for: self.view, animated: true)
            guard let weatherData = data else { return }
            
            self.weatherViewModel = WeatherViewModel(weather: weatherData)
            self.fiveDayForecast = self.fiveDayForecast(weatherList: self.weatherViewModel!.list)
            self.updateView(weatherViewModel: self.weatherViewModel!)
        }
        
            Locator.location(fromCoordinates: CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lon)!), using: .google, onSuccess: { places in
                DispatchQueue.main.async {
                    self.formattedAddressLabel.text = places[0].country
                    self.cityNameTextLabel.text = places[0].city
                }
                
            }) { err in
                print(err)
            }
    }
    @IBAction func SearchLocation(_ sender: Any) {
        let searchVC = ABCGooglePlacesSearchViewController()
        searchVC.delegate = self
        let navController = UINavigationController(rootViewController: searchVC)
        self.present(navController, animated: true)
    }
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController!, didReturn place: ABCGooglePlace!) {
        
        let lat = String(format: "%.2f", place.location.coordinate.latitude)
        let long = String(format: "%.2f", place.location.coordinate.longitude)
        
        self.cityNameTextLabel.text = place.name
        self.coordinatesTextLabel.text = "\(lat), \(long)"
        print(place.location, place.name, place.formatted_address)
        fetchWeatherData(lat: Float(place.location.coordinate.latitude), lon: Float(place.location.coordinate.longitude))
    }
    
    
    @IBAction func FindCurrentLocation(_ sender: Any) {
        
        currentLocationButton.isHidden = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        findCurrentLocation()
    }
    
    fileprivate func updateView(weatherViewModel: WeatherViewModel) {
        self.weatherDataTableView.reloadData()
        print("Current Temperatur : \(weatherViewModel.currentTemperature)")
        self.currentTemperature.text = weatherViewModel.currentTemperature
//        self.cityNameTextLabel.text = weathertViewModel.city
        self.coordinatesTextLabel.text = weatherViewModel.lat_long
        self.minMaxLabel.text = weatherViewModel.min_max
        self.mainWeatherInfoLabel.text = weatherViewModel.weatherInfo
        self.windRainPercentageLabel.text = weatherViewModel.windRainPercentage
    }
    
    func findCurrentLocation() {
        
        Locator.currentPosition(accuracy: .block, onSuccess: { location in
            self.fetchWeatherData(lat: Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
            
        }, onFail: { error ,last  in
            print(error.localizedDescription)
        })
    }
    
    func fiveDayForecast(weatherList: [list]) -> [list]{
        
        var reducedList = [list]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<weatherList.count-1 {
            let dateString = weatherList[i].dt_txt.split(separator: " ")[0]
            let date = dateFormatter.date(from: String(dateString))
            let dateString1 = weatherList[i+1].dt_txt.split(separator: " ")[0]
            let date1 = dateFormatter.date(from: String(dateString1))

            if date != date1 {
               reducedList.append(weatherList[i])
            }
        }
        print(reducedList.count)
        return reducedList
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayForecast.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.weatherDataTableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherTableViewCell
        let index = indexPath.row
        if fiveDayForecast.count > 0 {
            let foreCastViewModel = ForecastViewModel(list: fiveDayForecast[index])
            cell.weekDay.text = foreCastViewModel.day
            cell.weatherIcon.imageFrom(link: (foreCastViewModel.icon))
            cell.minmaxTemp.text = foreCastViewModel.min_max
        }
        
        return cell
    }
}
