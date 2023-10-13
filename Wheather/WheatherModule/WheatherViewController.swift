//
//  MainViewController.swift
//  Wheather
//
//  Created by Александра Тимонова on 06.10.2023.
//

import UIKit



class WheatherViewController: UIViewController {

  
    //MARK: - IBOutlets
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontSise.size25 , weight: .medium)
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var currentTemp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontSise.size60)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var currentWind: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontSise.size18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontSise.size15)
        label.text = "По часам"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var weekLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: FontSise.size15)
        label.text = "На неделю"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var hourlyView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundViewColor
        view.layer.cornerRadius = .cornerRadius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var weekView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundViewColor
        view.layer.cornerRadius = .cornerRadius15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        collectionView.layer.cornerRadius = .cornerRadius15
        return collectionView
    }()
    private var tabBarView = TabBarView()
    private let scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           return scrollView
    }()
    private let contentView: UIView = {
         let contentView = UIView()
         contentView.translatesAutoresizingMaskIntoConstraints = false
         return contentView
     }()

   
    //MARK: - Lets/Vars
    private var viewModel: IWheatherViewModel!
    //MARK: - Lificycle funcs
    init(viewModel: IWheatherViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backproundColor
        viewModel.bind()
        setUpTablesView()
        addSubviews()
        setUpUI()
        
        titleLabel.text = viewModel.nameOfCity
        tabBarView.delegate = self
        configureModel()
        viewModel.callService()
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // viewModel.callService()
        
    }
    
   
    //MARK: - Flow funcs
    func setUpTablesView(){
        tableView.dataSource = self
        tableView.register(WeekTableViewCell.self, forCellReuseIdentifier: WeekTableViewCell.identifier)
        tableView.isScrollEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func configureModel() {
            viewModel.didItemsUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.currentWind.text = String( (self?.viewModel.weatherForecastList?.current_weather.windspeed)!) + " м/с"
                    self?.currentTemp.text = String( (self?.viewModel.weatherForecastList?.current_weather.temperature)!) + .degreeCelsius
                    self?.tableView.reloadData()
                    self?.collectionView.reloadData()
                }
            }
        }
}
//MARK: - Private Extension
private extension WheatherViewController {
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(currentWind)
        contentView.addSubview(titleLabel)
        contentView.addSubview(currentTemp)
        contentView.addSubview(hourlyView)
        contentView.addSubview(weekView)
        weekView.addSubview(tableView)
        weekView.addSubview(weekLabel)
        hourlyView.addSubview(collectionView)
        hourlyView.addSubview(hourLabel)
        view.addSubview(tabBarView)
    }
    func setUpUI() {
       
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        // Настройка ограничений для scrollView
              scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
              scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
              scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
              scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
              
              // Настройка ограничений для contentView
              contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
              contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
              contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
              contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
              contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true


        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .offset100),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: .offset20),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -.offset20)
        ])
        NSLayoutConstraint.activate([
            currentTemp.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            currentTemp.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .offset20)
        ])
        NSLayoutConstraint.activate([
            currentWind.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            currentWind.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: .offset20)
        ])
        NSLayoutConstraint.activate([
            hourlyView.topAnchor.constraint(equalTo: currentWind.bottomAnchor, constant: .offset20),
            hourlyView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .offset20),
            hourlyView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.offset20),
            hourlyView.heightAnchor.constraint(equalToConstant: .offset130)
        ])
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: hourlyView.topAnchor, constant: .offset20),
            hourLabel.leftAnchor.constraint(equalTo: hourlyView.leftAnchor, constant: .offset20)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor ,constant: .offset10),
            collectionView.rightAnchor.constraint(equalTo: hourlyView.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: hourlyView.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: hourlyView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            weekView.topAnchor.constraint(equalTo: hourlyView.bottomAnchor, constant: .offset20),
            weekView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .offset20),
            weekView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.offset20),
            weekView.heightAnchor.constraint(equalToConstant: .offset360)
        ])
        NSLayoutConstraint.activate([
            weekLabel.topAnchor.constraint(equalTo: weekView.topAnchor, constant: .offset20),
            weekLabel.leftAnchor.constraint(equalTo: weekView.leftAnchor, constant: .offset20)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: weekLabel.bottomAnchor ,constant: .offset10),
            tableView.rightAnchor.constraint(equalTo: weekView.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: weekView.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: weekView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            tabBarView.heightAnchor.constraint(equalToConstant: .offset60),
            tabBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tabBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
//MARK: - MenuViewController TabBar Extension
extension WheatherViewController: TabBarViewDelegate {
    func rightMenuButtonTouched() {
        if let navigationController = self.navigationController {
            let newViewModel = MenuViewModel(manager: GeopositionNetworkService())
            let newViewController =  MenuViewController(viewModel: newViewModel)
            navigationController.pushViewController(newViewController, animated: true)
            var updatedViewControllers = navigationController.viewControllers
            updatedViewControllers.remove(at: updatedViewControllers.count - 2)
            navigationController.viewControllers = updatedViewControllers
        }

    }
}
//MARK: - UITableViewDataSource
extension WheatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOrWeekRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.identifier, for: indexPath) as? WeekTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureView(model: viewModel.getWeekWeatherForecast(index: indexPath.row)!)
        return cell
    }
    
}
//MARK: - MenuViewController UICollectionViewDelegate UICollectionViewDataSource
extension WheatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOrHourlyRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureView(model: viewModel.getHourlyWeatherForecast(index: indexPath.row)!)
        return cell
    }
    
    
}
