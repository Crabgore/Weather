//
//  DetailedViewController.swift
//  
//
//  Created by Mihail on 09.06.2021.
//

import UIKit

class DetailedViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var weather: WeatherList?
    var city: City?
    
    @IBOutlet var cityName: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var temp: UILabel!
    @IBOutlet var feelsLike: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var rain: UILabel!
    @IBOutlet var clouds: UILabel!
    @IBOutlet var visibility: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    @IBOutlet var seaLevel: UILabel!
    @IBOutlet var grndLevel: UILabel!
    @IBOutlet var overView: UILabel!
    @IBOutlet var back: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        back.layer.cornerRadius = 5
        back.backgroundColor = UIColor(rgb: 0xE9EEFA)
        
        cityName.text = city?.name
        setTime()
        setImage()
        setTemp(temperature: weather?.main?.temp ?? 0, view: temp)
        setTemp(temperature: weather?.main?.feelsLike ?? 0, view: feelsLike)
        setSpeed()
        rain.text = String(format: "%.0f", weather?.rain?.the3H ?? 0) + "%"
        clouds.text = String(format: "%.0f", weather?.clouds?.all ?? 0) + "%"
        visibility.text = String(weather?.visibility ?? 0)
        humidity.text = String(weather?.main?.humidity ?? 0) + "%"
        seaLevel.text = String(weather?.main?.seaLevel ?? 0) + " hPa"
        grndLevel.text = String(weather?.main?.grndLevel ?? 0) + " hPa"
        overView.text = weather?.weather?[0].weatherDescription
    }
    
    private func setTime() {
        let dayTimePeriodFormatter = DateFormatter()
        let timeConfig = userDefaults.integer(forKey: TIME)
        if timeConfig == 2 {
            dayTimePeriodFormatter.dateFormat = "hh:mm"
        } else {
            dayTimePeriodFormatter.dateFormat = "HH:mm"
        }
        
        sunrise.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: Double(city?.sunrise ?? 0)))
        sunset.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: Double(city?.sunset ?? 0)))
        
        dayTimePeriodFormatter.dateFormat = "dd/MM"
        time.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: Double(weather?.dt ?? 0)))
    }
    
    private func setImage() {

        let icon = weather?.weather?[0].icon ?? "10d"
        let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
        let data = try? Data(contentsOf: url!)
        weatherImage.image = UIImage(data: data!)
    }
    
    private func setTemp(temperature: Double, view: UILabel) {
        let tempConfig = userDefaults.integer(forKey: TEMP)
        if tempConfig == 1 {
            let mTemp = (temperature * 1.8) + 32
            view.text = String(format: "%.0f", mTemp) + "°"
        } else {
            view.text = String(format: "%.0f", temperature) + "°"
        }
    }
    
    private func setSpeed() {
        let timeConfig = userDefaults.integer(forKey: SPEED)
        if timeConfig == 1 {
            let speed = ((weather?.wind?.speed ?? 0) * 18) / 5
            windSpeed.text = String(format: "%.0f", speed) + " Km/h"
        } else {
            windSpeed.text = String(format: "%.0f", weather?.wind?.speed ?? 0) + " m/s"
        }
    }
}
