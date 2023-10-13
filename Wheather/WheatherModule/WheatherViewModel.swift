//
//  MainViewModel.swift
//  Wheather
//
//  Created by Александра Тимонова on 06.10.2023.
//

//MARK: - Inputs
import Foundation
import RxSwift
import RxCocoa




extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
protocol IWheatherViewModel {
    
    var didItemsUpdated: (() -> Void)? { get set }
    var coordinates: Coordinates! { get set }
    var weatherForecastList: WeatherForecast? { get set }
    var nameOfCity: String! { get set }
    init(cityName: String, coordinates: Coordinates, manager:  WheatherNetworkProtocol)
    func bind()
    func callService()
    func numberOrWeekRows() -> Int
    func numberOrHourlyRows() -> Int
    func getWeekWeatherForecast(index: Int) -> WeekForecast?
    func getHourlyWeatherForecast(index: Int) -> HourlyWeather?
}


class WheatherViewModel: IWheatherViewModel {
    //MARK: - Events
    var didItemsUpdated: (() -> Void)?
    //MARK: - Lets/Vars
    var coordinates: Coordinates! {
        didSet {
            callService()
        }
    }
    
    var weatherForecastList: WeatherForecast? {
        didSet {
            didItemsUpdated?()
        }
    }
    var disposeBag  = DisposeBag()
    var nameOfCity: String!
    let weatherNetwork: WheatherNetworkProtocol!
    //MARK: - Lificycle funcs
    required init(cityName: String, coordinates: Coordinates, manager:  WheatherNetworkProtocol) {
        self.weatherNetwork = manager
        self.coordinates = coordinates
        self.nameOfCity = cityName
       
    }
    //MARK: - Flow funcs
    func bind() {
        weatherNetwork.publishRelay.subscribe { event in
            if let element = event.element {
                if let data = try? JSONDecoder().decode(WeatherForecastResponse.self, from: element) {
                    self.weatherForecastList = self.remakeToWeatherForecast(responseModel: data)
                }
            }
        }.disposed(by: disposeBag)

    }
   
    func callService() {
        weatherNetwork.sendRequest(coordinates: coordinates, requestType: RequestType.GET)
     
    }

   

    func numberOrWeekRows() -> Int {
        return self.weatherForecastList?.weekForecast.count ?? 0
    }
    func numberOrHourlyRows() -> Int {
      
        return self.weatherForecastList?.hourly.count ?? 0
    }

    func getWeekWeatherForecast(index: Int) -> WeekForecast? {
        return self.weatherForecastList?.weekForecast[index]
    }
    func getHourlyWeatherForecast(index: Int) -> HourlyWeather? {
        return self.weatherForecastList?.hourly[index]
    }
    
    private func remakeToWeatherForecast(responseModel: WeatherForecastResponse ) -> WeatherForecast {
       
        var hourlyArray = [HourlyWeather]()
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let currentTime = inputDateFormatter.string(from: Date())
        let nowIndex = responseModel.hourly.time.firstIndex(where: { $0 >= currentTime
        })
        for index in 0..<responseModel.hourly.time.count{
            hourlyArray.append(HourlyWeather(time:  responseModel.hourly.time[index], temperature_2m: responseModel.hourly.temperature_2m[index], relativehumidity_2m: responseModel.hourly.relativehumidity_2m[index], windspeed_10m: responseModel.hourly.windspeed_10m[index]))
        }
        var todayForecast = [HourlyWeather]()
        for index in (nowIndex ?? 0)..<(nowIndex ?? 0) + 24{
            todayForecast.append(hourlyArray[index])
        }
        let weekForecast = getWeekForecast(forecast: hourlyArray)
       
        return WeatherForecast(latitude: responseModel.latitude, longitude: responseModel.longitude, current_weather: responseModel.current_weather, hourly: todayForecast, weekForecast: weekForecast)
    }
    private func getWeekForecast(forecast: [HourlyWeather]) -> [WeekForecast] {
        var weekForecast = [WeekForecast]()
        
        let chunkedArray = forecast.chunked(into: 24)

        for subarray in chunkedArray {
            let array = subarray.sorted { $0.temperature_2m < $1.temperature_2m }
            weekForecast.append(WeekForecast(date: array.first!.time, maxTemperature: array.last!.temperature_2m, minTemperature: array.first!.temperature_2m))
        }

        return weekForecast
    }
    
}
