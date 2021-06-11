//
//  SettingsViewController.swift
//  Weather
//
//  Created by Mihail on 09.06.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet var temp: UISegmentedControl!
    @IBOutlet var speed: UISegmentedControl!
    @IBOutlet var time: UISegmentedControl!
    @IBOutlet var sView: UIView!
    @IBOutlet var setBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    @IBAction func tempAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            userDefaults.setValue(1, forKey: TEMP)
        } else {
            userDefaults.setValue(2, forKey: TEMP)
        }
    }
    
    @IBAction func speedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            userDefaults.setValue(1, forKey: SPEED)
        } else {
            userDefaults.setValue(2, forKey: SPEED)
        }
    }
    
    @IBAction func timeAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            userDefaults.setValue(1, forKey: TIME)
        } else {
            userDefaults.setValue(2, forKey: TIME)
        }
    }
    
    @IBAction func setAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .blue
        sView.layer.cornerRadius = 5
        setBtn.layer.cornerRadius = 5
        
        switch userDefaults.integer(forKey: TEMP) {
        case 1:
            temp.selectedSegmentIndex = 1
        case 2:
            temp.selectedSegmentIndex = 2
        default:
            print("")
        }
        
        switch userDefaults.integer(forKey: SPEED) {
        case 1:
            speed.selectedSegmentIndex = 1
        case 2:
            speed.selectedSegmentIndex = 2
        default:
            print("")
        }
        
        switch userDefaults.integer(forKey: TIME) {
        case 1:
            time.selectedSegmentIndex = 1
        case 2:
            time.selectedSegmentIndex = 2
        default:
            print("")
        }
    }
}
