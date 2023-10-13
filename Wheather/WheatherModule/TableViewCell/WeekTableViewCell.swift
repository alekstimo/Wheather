//
//  WeekTableViewCell.swift
//  Wheather
//
//  Created by Александра Тимонова on 08.10.2023.
//

import UIKit

final class WeekTableViewCell: UITableViewCell {

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
        private var maxTempLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: FontSise.size15)
            return label
        }()
    private var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: FontSise.size15)
        return label
    }()

        
        //MARK: - Lificycle funcs
        override func awakeFromNib() {
            super.awakeFromNib()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            timeLabel.text = nil
            maxTempLabel.text = nil
            minTempLabel.text = nil
        }
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            self.backgroundColor = .clear
            setUp()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: - Flow funcs
        func configureView(model: WeekForecast) {
            timeLabel.text = formatTime(time:model.date)
            maxTempLabel.text = String(model.maxTemperature) + .degreeCelsius
            minTempLabel.text = String(model.minTemperature) + .degreeCelsius
        }

    }

    //MARK: - Private extension
    private extension WeekTableViewCell {
        func setUp() {
            self.addSubview(timeLabel)
            self.addSubview(maxTempLabel)
            self.addSubview(minTempLabel)
            
            
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
            minTempLabel.translatesAutoresizingMaskIntoConstraints = false
           
            
            NSLayoutConstraint.activate([
                timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: .offset10)
            ])
            NSLayoutConstraint.activate([
                minTempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                minTempLabel.leftAnchor.constraint(greaterThanOrEqualTo: timeLabel.rightAnchor, constant: .offset10)
            ])
            NSLayoutConstraint.activate([
                maxTempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                maxTempLabel.leftAnchor.constraint(equalTo: minTempLabel.rightAnchor, constant: .offset40),
                maxTempLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -.offset10)
            ])
        }
        func formatTime(time: String) -> String {
             let inputDateFormatter = DateFormatter()
             inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

             let outputDateFormatter = DateFormatter()
             outputDateFormatter.dateFormat = "dd"

             if let date = inputDateFormatter.date(from: time) {
                 let formattedString = outputDateFormatter.string(from: date)
                 return formattedString
             } else {
                 return time
             }

         }
    }
