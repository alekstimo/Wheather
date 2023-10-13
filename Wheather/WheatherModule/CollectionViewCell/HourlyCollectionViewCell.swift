//
//  HourlyCollectionViewCell.swift
//  Wheather
//
//  Created by Александра Тимонова on 08.10.2023.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - IBOutlets
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: FontSise.size15)
        return label
    }()
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: FontSise.size15)
        return label
    }()

    
    //MARK: - Lificycle funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        tempLabel.text = nil

    }
   

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setUp()
    }
    //MARK: - Flow funcs
    func configureView(model: HourlyWeather) {
        timeLabel.text = formatTime(time: model.time)
        tempLabel.text = String(model.temperature_2m) + .degreeCelsius
    }

}

//MARK: - Private extension
private extension HourlyCollectionViewCell {
    func setUp() {
        self.addSubview(timeLabel)
        self.addSubview(tempLabel)

        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: .offset10),
            
        ])

    }
   func formatTime(time: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "HH"

        if let date = inputDateFormatter.date(from: time) {
            let formattedString = outputDateFormatter.string(from: date)
            return formattedString
        } else {
            return time
        }

    }
}
