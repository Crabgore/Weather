//
//  OnboardViewController.swift
//  Weather
//
//  Created by Mihail on 08.06.2021.
//

import UIKit
import CoreLocation

class OnboardViewController: UIViewController, CLLocationManagerDelegate {
    
    private let userDefaults = UserDefaults.standard
    private let locationManager = CLLocationManager()
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var useBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    
    @IBAction func useAction(_ sender: Any) {
        userDefaults.setValue(false, forKey: IS_PERMITTED)
        MyLocationManager.shared.requestWhenInUse(callback: popBack)
    }
    
    @IBAction func noAction(_ sender: Any) {
        userDefaults.setValue(true, forKey: IS_PERMITTED)
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .blue
        useBtn.layer.cornerRadius = 5
        titleText.text = "Разрешить приложению  Weather использовать данные о местоположении вашего устройства\n\nЧтобы получить более точные прогнозы погоды во время движения или путешествия\n\nВы можете изменить свой выбор в любое время из меню приложения"
        titleText.textColor = .white
    }
    
    private func popBack() {
        navigationController?.popToRootViewController(animated: true)
    }
}
