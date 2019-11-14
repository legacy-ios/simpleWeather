//
//  WeatherManager.swift
//  SimpleWeather
//
//  Created by jungwooram on 2019-11-13.
//  Copyright © 2019 jungwooram. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    
    let headers = [
        "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
        "x-rapidapi-key": "496cf3640dmsha72401c82942c55p1a0511jsn65ca07b4b271"
    ]
    let wetherUrl = "https://community-open-weather-map.p.rapidapi.com/weather?units=metric&mode=json"
    
    func fetchWeather(cityName : String){
        let urlString = "\(wetherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(longitude: Double, latitude: Double){
        let urlString = "\(wetherUrl)&lon=\(longitude)&lat=\(latitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String){

        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            // Set headers
            request.setValue("community-open-weather-map.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host" )
            request.setValue("496cf3640dmsha72401c82942c55p1a0511jsn65ca07b4b271", forHTTPHeaderField: "x-rapidapi-key")
            
            let urlSession = URLSession(configuration: .default)
            
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weatherModel = WeatherModel(conditionId: conditionId, cityName: cityName, temperature: temperature)
            return weatherModel
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}



