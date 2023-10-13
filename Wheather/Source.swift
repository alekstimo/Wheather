//
//  Source.swift
//  Wheather
//
//  Created by Александра Тимонова on 11.10.2023.
//

import Foundation
import UIKit

extension String {
    static let currentPositionKey = "CurrentPosition"
    static let cityInfoKey = "CityInfo"
    static let degreeCelsius = "°"
}
extension CGFloat {
    static let offset10 = 10.0
    static let offset20 = 20.0
    static let offset40 = 40.0
    static let offset60 = 60.0
    static let offset100 = 100.0
    static let offset130 = 130.0
    static let offset360 = 360.0
    static let cornerRadius15 = 15.0
}
struct FontSise {
    static let size25 = 25.0
    static let size60 = 60.0
    static let size15 = 15.0
    static let size18 = 18.0
}

struct Images {
    static let titleImage = UIImage(named: "sun")
    static let menuImage = UIImage(named: "menu")
}

struct Colors {
    static let backproundColor = UIColor(named: "backgroundColor")
    static let backgroundTabBarColor = UIColor(named: "backgroundTabBarColor")
    static let backgroundViewColor = UIColor(named: "backgroundViewColor")
    static let collectionCellColor = UIColor(named: "collectionCellColor")
    static let seacrhBarColor = UIColor(named: "seacrhBarColor")
    static let searchBarBackgroundColor = UIColor(named: "searchBarBackgroundColor")
}
