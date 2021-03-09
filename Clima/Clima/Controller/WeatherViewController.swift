//
//  ViewController.swift
//  Clima
//
//  Created by manukant Tyagi on 28/02/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var search: UITextField!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        super.viewDidLoad()
        search.delegate = self
    }
   
//MARK: - WeatherManagerDelegate
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchButtonPressed(_ sender: UIButton){
        search.endEditing(true)
        print(search.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print(search.text!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  let city = textField.text {
            weatherManager.fetchWeather(city: city)
        }
        search.text = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
            
        }else {
            textField.placeholder = "type something"
            return false
        }
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.getConditionName)
            self.cityLabel.text = weather.cityName
        }
       

    }
    func didFailWithError(error: Error?) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

