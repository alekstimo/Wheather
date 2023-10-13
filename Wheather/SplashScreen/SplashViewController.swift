//
//  SplashViewController.swift
//  Wheather
//
//  Created by Александра Тимонова on 10.10.2023.
//

//MARK: - Inputs
import UIKit
import CoreLocation

class SplashViewController: UIViewController {

    //MARK: - IBOutlets
    var sunImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.titleImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Lets/Vars
    let locationManager = CLLocationManager()
    var currentCity: String!
    var currentCorrdinates: CLLocationCoordinate2D!
    
    //MARK: - Lificycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backproundColor
        setUpUI()
        getLocation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageView()
    }
    //MARK: - Flow funcs
    private func animateImageView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat], animations: {
            self.sunImageView.transform = self.sunImageView.transform.rotated(by: CGFloat.pi / 2)
        }, completion: nil)
    }

    private func setUpUI() {
        view.addSubview(sunImageView)
        
        NSLayoutConstraint.activate([
            sunImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sunImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private  func getLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    private func  openCurrentWheatherViewController() {
        if let navigationController = self.navigationController {
            let viewModel = WheatherViewModel(cityName: currentCity, coordinates: Coordinates(lon: "\(currentCorrdinates.longitude)", lat: "\( currentCorrdinates.latitude)"), manager: WeatherNetworkService())
            let cityInfo = CityInfo(name: currentCity, position:  Coordinates(lon: "\(currentCorrdinates.longitude)", lat: "\( currentCorrdinates.latitude)"))
            UserDefaults.standard.saveData(someData: cityInfo, key: .currentPositionKey)
            let viewController = WheatherViewController(viewModel: viewModel)
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    

}
//MARK: - Extensions
extension SplashViewController:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        
        let geoCoder = CLGeocoder()
        currentCity = "Текущее место"
       
          //TODO: название городa подтягивается уже после выполнения
            geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                if let city = placemarks?[0].locality {
                    self.currentCity = city
                }
            })
             

        currentCorrdinates = userLocation.coordinate
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.openCurrentWheatherViewController()
        }
        
      }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to get location: \(error.localizedDescription)")
       }

}

