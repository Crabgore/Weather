//
//  OnboardViewController.swift
//  Weather
//
//  Created by Mihail on 08.06.2021.
//

import UIKit
import CoreLocation

class OnboardViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var useBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    
    @IBAction func useAction(_ sender: Any) {
        Settings.isPermitted = false
        MyLocationManager.shared.requestWhenInUse(callback: popBack)
    }
    
    @IBAction func noAction(_ sender: Any) {
        Settings.isPermitted = true
        popBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        setupView()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .blue
        useBtn.layer.cornerRadius = 5
        titleText.text = "Разрешить приложению  Weather использовать данные о местоположении вашего устройства\n\nЧтобы получить более точные прогнозы погоды во время движения или путешествия\n\nВы можете изменить свой выбор в любое время из меню приложения"
        titleText.textColor = .white
    }
    
    private func popBack() {
        Settings.isAppLaunchedOnce = true
        navigationController?.popToRootViewController(animated: true)
    }
}
