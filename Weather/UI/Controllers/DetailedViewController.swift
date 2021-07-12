//
//  DetailedViewController.swift
//  
//
//  Created by Mihail on 09.06.2021.
//

import UIKit

class DetailedViewController: UIViewController {
    lazy var dateFormatter = DateFormatter()
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        back.layer.cornerRadius = 5
        back.backgroundColor = UIColor(rgb: 0xE9EEFA)
        
        cityName.text = city?.name
        setTime()
        setImage()
        setTemp(currentTemp: weather?.main?.temp ?? 0, feelsLikeTemp: weather?.main?.feelsLike ?? 0)
        setSpeed()
        setTextInfo()
    }
    
    private func setTime() {
        if Settings.time == 2 {
            dateFormatter.dateFormat = "hh:mm"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        sunrise.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(city?.sunrise ?? 0)))
        sunset.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(city?.sunset ?? 0)))
        
        dateFormatter.dateFormat = "dd/MM"
        time.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(weather?.dt ?? 0)))
    }
    
    private func setImage() {
        let icon = weather?.weather?.first?.icon ?? "10d"
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") else {
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        weatherImage.image = UIImage(data: data)
    }
    
    private func setTemp(currentTemp: Double, feelsLikeTemp: Double) {
        temp.text = getProperCurrentTemp(receivedTemp: currentTemp)
        feelsLike.text = getProperCurrentTemp(receivedTemp: feelsLikeTemp)
    }
    
    private func setSpeed() {
        if Settings.speed == 1 {
            let speed = ((weather?.wind?.speed ?? 0) * 18) / 5
            windSpeed.text = String(format: "%.0f", speed) + " Km/h"
        } else {
            windSpeed.text = String(format: "%.0f", weather?.wind?.speed ?? 0) + " m/s"
        }
    }
    
    private func setTextInfo() {
        rain.text = String(format: "%.0f", (weather?.pop ?? 0) * 100) + "%"
        clouds.text = String(weather?.clouds?.all ?? 0) + "%"
        visibility.text = String(weather?.visibility ?? 0)
        humidity.text = String(weather?.main?.humidity ?? 0) + "%"
        seaLevel.text = String(weather?.main?.seaLevel ?? 0) + " hPa"
        grndLevel.text = String(weather?.main?.grndLevel ?? 0) + " hPa"
        overView.text = getProperDesc(desc: weather?.weather?.first?.weatherDescription ?? "")
    }
}
