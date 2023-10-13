//
//  CityInfo.swift
//  Wheather
//
//  Created by Александра Тимонова on 13.10.2023.
//

import Foundation

struct Coordinates: Codable {
    let lon: String
    let lat: String
}
struct CityInfoResponse: Codable {
    let value: String
    let levels: Levels
    struct Levels: Codable {
        let level1: Level1
        
        enum CodingKeys: String, CodingKey {
            case level1 = "1"
        }
        struct Level1: Codable {
            
            let geoCenter: Coordinates
            
            
            enum CodingKeys: String, CodingKey {
                
                case geoCenter = "geo_center"
                
            }
        }
    }
    
}

struct CityInfo: Codable {
    let name: String
    let position: Coordinates
    
    static func createDefault() -> CityInfo {
        .init(name: "Воронеж", position: Coordinates(lon: "39.1969229", lat: "51.6593332"))
    }
    init(name: String, position: Coordinates){
        self.name = name
        self.position = position
    }
    
}
