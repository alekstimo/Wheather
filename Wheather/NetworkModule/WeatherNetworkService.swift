//
//  WeatherNetworkService.swift
//  Wheather
//
//  Created by Александра Тимонова on 06.10.2023.
//

//MARK: - Inputs
import Foundation
import RxCocoa
import RxSwift

//MARK: - Constants
enum ErrorsStates: String {
    case WrongURL
    case WrongAnswerFromServer
    case ErrorInRequest
    case DataMissingFromResponse
}

enum RequestType: String {
    case GET
    case POST
}
//MARK: - Protocol
protocol WheatherNetworkProtocol {
    var publishRelay: PublishRelay<Data> { get }
    func sendRequest(coordinates: Coordinates?, requestType: RequestType)
}

final class WeatherNetworkService: WheatherNetworkProtocol {
    //MARK: - Lets/Vars
    private let baseURL = "https://api.open-meteo.com/v1/forecast?"
    private let endpoint = "&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m"
    let publishRelay =  PublishRelay<Data>()
    
   
    //MARK: - Flow funcs
    func sendRequest(coordinates: Coordinates?, requestType: RequestType) {
        guard let coordinates = coordinates else { return }
        guard let url = URL(string: baseURL + "latitude=\(coordinates.lat)&longitude=\(coordinates.lon)" + endpoint) else {
            print(ErrorsStates.WrongURL.rawValue)
            return
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print( ErrorsStates.ErrorInRequest.rawValue + ": \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print(ErrorsStates.WrongAnswerFromServer.rawValue)
                return
            }
            
            guard let data = data else {
                print(ErrorsStates.DataMissingFromResponse.rawValue)
                return
            }
            
            self.publishRelay.accept(data)
            
        }
        task.resume()
    }
}
