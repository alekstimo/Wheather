//
//  MenuViewModel.swift
//  Wheather
//
//  Created by Александра Тимонова on 09.10.2023.
//

//MARK: - Inputs
import Foundation
import RxSwift

protocol IMenuViewModel {
    init(manager: GeopositionNetworkServiceProtocol)
    func bind()
    func addCityToCollection(index: Int)
    func numberOfCitiesRows() -> Int
    func numberOfResponseCitiesRows() -> Int
    func getCityFromResponse(index: Int) -> CityInfoResponse
    func getCityInfo(index: Int) -> CityInfo
    var didArrayOfResponseUpdated: (() -> Void)? { get set }
    var searchingString: String? { get set }
}

final class MenuViewModel: IMenuViewModel {
    //MARK: - Events
    var didArrayOfResponseUpdated: (() -> Void)?
    //MARK: - Lets/Vars
    var arrayOfCities: [CityInfo] = []
    var responseArray: [CityInfoResponse] = [] {
        didSet {
            didArrayOfResponseUpdated?()
        }
    }
    
    let disposeBag = DisposeBag()
    let manager: GeopositionNetworkServiceProtocol!
    var searchingString: String? {
        didSet {
            manager.sendRequest(cityName: searchingString, requestType: RequestType.GET)
        }
    }
    //MARK: - Lificycle funcs
    init(manager: GeopositionNetworkServiceProtocol) {
        self.manager = manager
        if let currentPosition = UserDefaults.standard.readData(type: CityInfo.self, key: .currentPositionKey) {
            arrayOfCities.append(currentPosition)
        }
        if let data = UserDefaults.standard.readData(type: [CityInfo].self, key: .cityInfoKey) {
            self.arrayOfCities += data
        }
       
    }
    
    //MARK: - Flow funcs
    func bind() {
        manager.publishRelay.subscribe { event in
            if let element = event.element {
                if let data = try? JSONDecoder().decode([CityInfoResponse].self, from: element) {
                  
                  
                    self.responseArray = self.correctCityName(array: data)
                }
            }
        }.disposed(by: disposeBag)
    }
    private func saveCities() {
        arrayOfCities.removeFirst()
        UserDefaults.standard.saveData(someData: arrayOfCities, key: .cityInfoKey)
    }
   
    func numberOfCitiesRows() -> Int {
       arrayOfCities.count
    }
    func addCityToCollection(index: Int) {
        let city = getCityFromResponse(index: index)
        if arrayOfCities.first(where: { $0.name == city.value
        }) != nil {
            return
        }
        arrayOfCities.append(CityInfo(name: city.value, position: city.levels.level1.geoCenter))
        saveCities()
    }
    func numberOfResponseCitiesRows() -> Int {
        responseArray.count
    }
    func getCityFromResponse(index: Int) -> CityInfoResponse {
       responseArray[index]
    }
    func getCityInfo(index: Int) -> CityInfo {
       arrayOfCities[index]
    }
    private func correctCityName(array: [CityInfoResponse]) -> [CityInfoResponse] {
        var newArray = [CityInfoResponse]()
        for elem in array {
            
            if let commaIndex = elem.value.firstIndex(of: ",") {
                let region = String(elem.value[elem.value.startIndex..<commaIndex]).trimmingCharacters(in: .whitespaces)
                let cityArea = String(elem.value[elem.value.index(after: commaIndex)..<elem.value.endIndex]).trimmingCharacters(in: .whitespaces)
                if let commaSecondIndex = cityArea.firstIndex(of: ",") {
                    let area = String(cityArea[cityArea.startIndex..<commaSecondIndex]).trimmingCharacters(in: .whitespaces)
                    let city = String(cityArea[cityArea.index(after: commaSecondIndex)..<cityArea.endIndex]).trimmingCharacters(in: .whitespaces)
                    newArray.append(CityInfoResponse(value: "\(city), \(area), \(region)", levels: elem.levels))
                } else {
                    
                    newArray.append(CityInfoResponse(value: "\(cityArea), \(region)", levels: elem.levels))
                }
            } else {
                newArray.append(elem)
            }

        }
        return newArray
    }
}
