//
//  ViewController.swift
//  Weather
//
//  Created by Mihail on 07.06.2021.
//

import UIKit
import CoreLocation

class MainViewController: UIPageViewController, CLLocationManagerDelegate, TitleChanger  {
    
    private let userDefaults = UserDefaults.standard
    private let inspector = Inspector()
    private let locationManager = CLLocationManager()
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(), self.newColoredViewController()]
    }()
    
    private func newColoredViewController() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherVC")
        (vc as! WeatherViewController).inspector = self.inspector
        (vc as! WeatherViewController).changer = self
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermission()
    }
    
    private func setupView() {
        locationManager.delegate = self
        dataSource = self
        
        let locationBtn = UIBarButtonItem(
            image: UIImage(named: "location")!.withRenderingMode(.alwaysOriginal),
            style: .plain, target: self, action: #selector(locationTapped))
        
        let menuBtn = UIBarButtonItem(
            image: UIImage(named: "menu")!.withRenderingMode(.alwaysOriginal),
            style: .plain, target: self, action: #selector(menuTapped))
        
        navigationItem.leftBarButtonItem = menuBtn
        navigationItem.rightBarButtonItem = locationBtn
    }
    
    @objc private func locationTapped() {
        navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingVC"), animated: true)
    }
    
    @objc private func menuTapped() {
        navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC"), animated: true)
    }
    
    private func checkPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if orderedViewControllers.count == 1 {
                orderedViewControllers.insert(newColoredViewController(), at: 0)
            }
            locationManager.requestLocation()
        case .notDetermined:
            let permission = userDefaults.bool(forKey: IS_PERMITTED)
            if permission {
                if orderedViewControllers.count > 1 {
                    orderedViewControllers.remove(at: 1)
                }
                if let firstViewController = self.orderedViewControllers.first {
                    self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
                }
            } else {
                navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingVC"), animated: true)
            }
        case .restricted, .denied:
            print("location denied")
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

protocol RealmInspector {
    func saveWeather(weather: Weather, id: String)
    func getWeather(id: String) -> Weather?
}