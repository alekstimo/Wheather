//
//  MenuCollectionViewCell.swift
//  Wheather
//
//  Created by Александра Тимонова on 09.10.2023.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - IBOutlets
    private var cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: FontSise.size18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    
    //MARK: - Lificycle funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.text = nil
        

    }
   

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.collectionCellColor
        self.layer.cornerRadius = .cornerRadius15
        setUp()
    }
    //MARK: - Flow funcs
    func configureView(model: CityInfo) {
        cityNameLabel.text = model.name
    }
}
//MARK: - Extensions
private extension MenuCollectionViewCell {
    func setUp() {
        self.addSubview(cityNameLabel)
        
        NSLayoutConstraint.activate([
            cityNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cityNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cityNameLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: .offset10),
            cityNameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -.offset10)
        ])
        
    }
}
