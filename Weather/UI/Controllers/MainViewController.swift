//
//  ViewController.swift
//  Weather
//
//  Created by Mihail on 07.06.2021.
//

import UIKit
import CoreLocation

class MainViewController: UIPageViewController, CLLocationManagerDelegate, TitleChanger  {
    
    private let inspector = Inspector()
    private let locationManager = CLLocationManager()
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        var controllers = [UIViewController]()
        controllers.append(self.makeNewViewController())
        
        var cities = Settings.city
        if cities.count > 0 {
            for city in cities {
                controllers.append(self.makeNewViewController(cityName: city))
            }
        }
        
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isAppAlreadyLaunchedOnce() {
            checkPermission()
        }
    }
    
    private func setupView() {
        locationManager.delegate = self
        dataSource = self
        
        let locationBtn = UIBarButtonItem(
            image: UIImage(named: "location")?.withRenderingMode(.alwaysOriginal),
            style: .plain, target: self, action: #selector(locationTapped))
        
        let menuBtn = UIBarButtonItem(
            image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal),
            style: .plain, target: self, action: #selector(menuTapped))
        
        navigationItem.leftBarButtonItem = menuBtn
        navigationItem.rightBarButtonItem = locationBtn
    }
    
    private func makeNewViewController(cityName: String? = nil) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherVC")
        (vc as! WeatherViewController).inspector = self.inspector
        (vc as! WeatherViewController).changer = self
        if cityName != nil {
            (vc as! WeatherViewController).cityName = cityName
        }
        return vc
    }
    
    private func checkPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            let permission = Settings.isPermitted
            if permission {
                if let firstViewController = self.orderedViewControllers.first {
                    self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
                }
            } else {
                navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingVC"), animated: true)
            }
        case .restricted, .denied:
            if let firstViewController = self.orderedViewControllers.first {
                self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            self.locationManager.getPlace(for: location) { placemark in
                guard let placemark = placemark else { return }
                
                if let city = placemark.locality {
                    if let firstViewController = self.orderedViewControllers.first {
                        (firstViewController as! WeatherViewController).cityName = city
                        self.setViewControllers([firstViewController],
                                                direction: .forward,
                                                animated: true,
                                                completion: nil)
                    }
                }
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("location error")
    }
    
    func changeTitle(title: String) {
        self.navigationItem.title = title
    }
    
    private func appendNewController() {
        orderedViewControllers.append(makeNewViewController())
    }
    
    @objc private func locationTapped() {
        let alertController = UIAlertController(title: "Введите название города на английском", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Введите название города на английском"
        }
        let saveAction = UIAlertAction(title: "Сохранить", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text != nil && !firstTextField.text!.isEmpty {
                self.appendNewController()
                if let firstViewController = self.orderedViewControllers.last {
                    self.setViewControllers([firstViewController],
                                            direction: .forward,
                                            animated: true,
                                            completion: nil)
                    (firstViewController as! WeatherViewController).setNewCity(newCityName: firstTextField.text!)
                }
            }
        })
        
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func menuTapped() {
        navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC"), animated: true)
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        if Settings.isAppLaunchedOnce == false {
                return true
            } else {
                Settings.isAppLaunchedOnce = false
                return false
            }
        }
}

// MARK: UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

// MARK: - Get Placemark
extension CLLocationManager {
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}
