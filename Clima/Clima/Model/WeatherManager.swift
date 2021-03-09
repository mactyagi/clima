//
//  WeatherManager.swift
//  Clima
//
//  Created by manukant Tyagi on 28/02/21.

//
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error?)
}
import Foundation
struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4addf95824899ff50986847132816825&units=metric"
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(with : urlString)
    }
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    func parseJSON(_ weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do{
          let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temprature = decodedData.main.temp
            let cityName = decodedData.name
            let weather = WeatherModel(cityName: cityName, temprature: temprature, ConditionId: id)
            return weather
            
            print(weather.getConditionName)
            print(weather.tempratureString)
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

