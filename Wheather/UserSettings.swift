//
//  UserSettings.swift
//  Wheather
//
//  Created by Кирилл Зезюков on 09.10.2023.
//

import Foundation
extension UserDefaults {
    func saveData<T: Encodable>(someData: T, key: String) {
        let data = try? JSONEncoder().encode(someData)
        set(data, forKey: key)
        
    }
    
    func readData<T: Decodable>(type: T.Type, key: String) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        let newData = try? JSONDecoder().decode(type, from: data)
        return newData
    }
}
