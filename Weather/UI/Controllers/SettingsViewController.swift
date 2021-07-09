//
//  SettingsViewController.swift
//  Weather
//
//  Created by Mihail on 09.06.2021.
//

import UIKit

class SettingsViewController: UIViewController {
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
            Settings.temp = 1
        } else {
            Settings.temp = 2
        }
    }
    
    @IBAction func speedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            Settings.speed = 1
        } else {
            Settings.speed = 2
        }
    }
    
    @IBAction func timeAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            Settings.time = 1
        } else {
            Settings.time = 2
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
        
        switch Settings.temp {
        case 1:
            temp.selectedSegmentIndex = 1
        case 2:
            temp.selectedSegmentIndex = 2
        default:
            print("")
        }
        
        switch Settings.speed {
        case 1:
            speed.selectedSegmentIndex = 1
        case 2:
            speed.selectedSegmentIndex = 2
        default:
            print("")
        }
        
        switch Settings.time {
        case 1:
            time.selectedSegmentIndex = 1
        case 2:
            time.selectedSegmentIndex = 2
        default:
            print("")
        }
    }
}
