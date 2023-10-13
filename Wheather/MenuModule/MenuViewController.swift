//
//  MenuViewController.swift
//  Wheather
//
//  Created by Александра Тимонова on 09.10.2023.
//

//MARK: - Inputs
import UIKit

class MenuViewController: UIViewController {
    
    //MARK: - IBOutlets
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private var searchBar: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = .cornerRadius15
        textField.textColor = .white
        textField.backgroundColor = Colors.searchBarBackgroundColor
        
        textField.layer.masksToBounds = true
        textField.returnKeyType = .search
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Поиск города",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.seacrhBarColor ?? .gray]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private var dropDownTabeView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    //MARK: - Lets/Vars
    var viewModel: IMenuViewModel!
    
    //MARK: - Lificycle funcs
     init(viewModel: IMenuViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        viewModel.bind()
        setUpUI()
        configureTableView()
        configureCollectionView()
        configureSearchBar()
        bind()
       
    }
    //MARK: - Flow funcs
    private func bind() {
        viewModel.didArrayOfResponseUpdated = { [weak self] in
            DispatchQueue.main.async {
               
                self?.addTableView()
                self?.dropDownTabeView.reloadData()
            }
        }
    }
    private func addTableView() {
       view.addSubview(dropDownTabeView)
        NSLayoutConstraint.activate([
           dropDownTabeView.topAnchor.constraint(equalTo: searchBar.bottomAnchor ),
           dropDownTabeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           dropDownTabeView.heightAnchor.constraint(equalToConstant: .offset130),
           dropDownTabeView.widthAnchor.constraint(equalToConstant: view.frame.width - .offset40)
        ])
    }
    private func configureTableView() {
        dropDownTabeView.delegate = self
        dropDownTabeView.dataSource = self
        dropDownTabeView.isScrollEnabled = false
    }
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    private func configureSearchBar() {
        
        searchBar.addTarget(self, action: #selector(searchBarEditingChanged), for: .editingChanged)
        searchBar.addTarget(self, action: #selector(searchBarDidTapOnExit), for: .editingDidEndOnExit)
        
    }
    private func setUpUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: .offset60),
            searchBar.heightAnchor.constraint(equalToConstant: .offset40),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: .offset40),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

   

}
//MARK: - MenuViewController TableView Extension
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfResponseCitiesRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.getCityFromResponse(index: indexPath.row).value
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open
        viewModel.addCityToCollection(index:  indexPath.row)
        let city = viewModel.getCityFromResponse(index: indexPath.row)
        if let navigationController = self.navigationController {
            let newViewModel = WheatherViewModel(cityName: city.value, coordinates: city.levels.level1.geoCenter, manager: WeatherNetworkService())
            let vc = WheatherViewController(viewModel: newViewModel)
            
            navigationController.pushViewController(vc, animated: true)
            var updatedViewControllers = navigationController.viewControllers
            updatedViewControllers.remove(at: updatedViewControllers.count - 2)
            navigationController.viewControllers = updatedViewControllers
        }
    }
    
    
}
//MARK: - MenuViewController searchBar Extension
extension MenuViewController {
    @objc func searchBarEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            if (dropDownTabeView.superview != nil) {
                dropDownTabeView.removeFromSuperview()
            }
            return
        }
        viewModel.searchingString = text
    }
    @objc func searchBarDidTapOnExit(_ sender: UITextField){
        if (dropDownTabeView.superview != nil) {
            dropDownTabeView.removeFromSuperview()
        }
    }
    
}
//MARK: - MenuViewController CollectionView Extension
extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCitiesRows()
    }
   

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? MenuCollectionViewCell {
            cell.configureView(model: viewModel.getCityInfo(index: indexPath.row))
            }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - .offset40, height: .offset100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .offset20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .offset20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigationController = self.navigationController {
            let city = viewModel.getCityInfo(index: indexPath.row)
            let newViewModel = WheatherViewModel(cityName: city.name, coordinates: city.position, manager: WeatherNetworkService())
            let vc = WheatherViewController(viewModel: newViewModel)
            navigationController.pushViewController(vc, animated: true)
            var updatedViewControllers = navigationController.viewControllers
            updatedViewControllers.remove(at: updatedViewControllers.count - 2)
            navigationController.viewControllers = updatedViewControllers
        }
        
    }
    

    
}
