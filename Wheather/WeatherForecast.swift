//
//  WeatherForecast.swift
//  Wheather
//
//  Created by Александра Тимонова on 06.10.2023.
//

import Foundation
struct WeatherForecastResponse: Codable {
    let latitude: Double
    let longitude: Double
    let current_weather: CurrentWeather
    let hourly: HourlyWeatherResponse
    
    struct HourlyWeatherResponse: Codable {
          let time: [String]
          let temperature_2m: [Double]
          let relativehumidity_2m: [Double]
          let windspeed_10m: [Double]
   }
}

 struct CurrentWeather: Codable {
    let time: String
    let temperature: Double
    let windspeed: Double
    let winddirection: Int
}
 

struct WeatherForecast {
    let latitude: Double
    let longitude: Double
    let current_weather: CurrentWeather
    let hourly: [HourlyWeather]
    let weekForecast: [WeekForecast]
}

struct HourlyWeather {
       let time: String
       let temperature_2m: Double
       let relativehumidity_2m: Double
       let windspeed_10m: Double
}
struct WeekForecast {
    let date: String
    let maxTemperature: Double
    let minTemperature: Double
}




