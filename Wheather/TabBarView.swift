//
//  TabBarView.swift
//  Wheather
//
//  Created by Александра Тимонова on 09.10.2023.
//

import UIKit
protocol TabBarViewDelegate {
    func rightMenuButtonTouched()
}

class TabBarView: UIView {
    //MARK: - IBOutlets
    private var rightMenuButton: UIButton = {
        let button = UIButton()
        let image = Images.menuImage
        button.setImage(image, for: .normal)
        button.setTitle("", for: .normal)
        return button
    }()
    //MARK: - lets/var
    var delegate: TabBarViewDelegate?
    
    //MARK: - lifecycle func
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.backgroundTabBarColor
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - flow func
    private func setUp() {
        self.addSubview(rightMenuButton)
        rightMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightMenuButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -.offset40),
            rightMenuButton.heightAnchor.constraint(equalToConstant: .offset20),
            rightMenuButton.widthAnchor.constraint(equalTo: rightMenuButton.heightAnchor, multiplier: 1),
            rightMenuButton.topAnchor.constraint(equalTo: self.topAnchor, constant: .offset20)
        ])
        rightMenuButton.addTarget(self, action: #selector(rightMenuButtonTouched), for: .touchUpInside)
    }
    @objc private func rightMenuButtonTouched(sender: UIButton) {
        delegate?.rightMenuButtonTouched()
    }
}
