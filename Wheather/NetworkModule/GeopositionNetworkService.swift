//
//  GeopositionNetworkService.swift
//  Wheather
//
//  Created by Александра Тимонова on 09.10.2023.
//

//MARK: - Inputs
import Foundation
import RxCocoa
import RxSwift



protocol GeopositionNetworkServiceProtocol {
    var publishRelay: PublishRelay<Data> { get }
    func sendRequest(cityName: String?, requestType: RequestType)
    //sendRequestForCityName
}

final class GeopositionNetworkService: GeopositionNetworkServiceProtocol {
    //MARK: - Lets/Vars
    var publishRelay = RxRelay.PublishRelay<Data>()
    private let baseURL = "https://api.geotree.ru/address.php?"
    private let apiKey = "81s5SEZo1Fir"
    
    //MARK: - Flow funcs
    func sendRequest(cityName: String?, requestType: RequestType) {
        guard let name = cityName, !name.isEmpty else { return }
        guard let url = URL(string: baseURL + "key=\(apiKey)&" + "limit=3&" + "term=\(urlencode(name) ?? "Москва")" + "&types=place") else {
            print(ErrorsStates.WrongURL.rawValue)
            return

        }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        request.addValue("utf-8", forHTTPHeaderField: "charset")
       
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(ErrorsStates.ErrorInRequest.rawValue + ": \(error)")
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
    private func urlencode(_ string: String) -> String? {
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._* "))
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

}




