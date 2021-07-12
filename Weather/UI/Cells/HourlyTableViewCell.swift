//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Mihail on 24.06.2021.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    lazy var dateFormatter = DateFormatter()
    let inset: CGFloat = 10
    var weather: WeatherList? {
        didSet {
            setDate()
            setTime()
            setTemp()
            setSpeed()
            cloudsValue.text = String(weather?.clouds?.all ?? 0) + "%"
            rainValue.text = String(format: "%.0f", (weather?.pop ?? 0) * 100) + "%"
        }
    }
    
    private let date: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temp: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feelsLikeImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feelslike")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let windImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wind")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rainImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rain")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cloudsImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloudness")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let feelsLike: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Ощущается как"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let wind: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Ветер"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rain: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Атмосферные осадки"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let clouds: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Облачность"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feelsLikeValue: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windValue: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rainValue: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cloudsValue: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(rgb: 0xE9EEFA)
        
        contentView.addSubviews(date, time, temp, feelsLikeImg, windImg, rainImg, cloudsImg, feelsLike, feelsLikeValue, wind, windValue, rain, rainValue, clouds, cloudsValue)
        
        let constraints = [
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            
            time.topAnchor.constraint(equalTo: date.bottomAnchor, constant: inset),
            time.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            
            temp.topAnchor.constraint(equalTo: time.bottomAnchor, constant: inset),
            temp.leadingAnchor.constraint(equalTo: time.leadingAnchor),
            temp.trailingAnchor.constraint(equalTo: time.trailingAnchor),
            
            feelsLikeImg.topAnchor.constraint(equalTo: date.bottomAnchor, constant: inset),
            feelsLikeImg.leadingAnchor.constraint(equalTo: time.trailingAnchor, constant: inset),
            feelsLike.topAnchor.constraint(equalTo: date.bottomAnchor, constant: inset),
            feelsLike.leadingAnchor.constraint(equalTo: feelsLikeImg.trailingAnchor, constant: inset),
            feelsLikeValue.topAnchor.constraint(equalTo: date.bottomAnchor, constant: inset),
            feelsLikeValue.leadingAnchor.constraint(equalTo: rainValue.leadingAnchor),
            
            windImg.topAnchor.constraint(equalTo: feelsLike.bottomAnchor, constant: inset),
            windImg.leadingAnchor.constraint(equalTo: time.trailingAnchor, constant: inset),
            wind.topAnchor.constraint(equalTo: feelsLike.bottomAnchor, constant: inset),
            wind.leadingAnchor.constraint(equalTo: feelsLike.leadingAnchor),
            windValue.topAnchor.constraint(equalTo: feelsLike.bottomAnchor, constant: inset),
            windValue.leadingAnchor.constraint(equalTo: rainValue.leadingAnchor),
            
            rainImg.topAnchor.constraint(equalTo: wind.bottomAnchor, constant: inset),
            rainImg.leadingAnchor.constraint(equalTo: time.trailingAnchor, constant: inset),
            rain.topAnchor.constraint(equalTo: wind.bottomAnchor, constant: inset),
            rain.leadingAnchor.constraint(equalTo: feelsLike.leadingAnchor),
            rainValue.topAnchor.constraint(equalTo: wind.bottomAnchor, constant: inset),
            rainValue.leadingAnchor.constraint(equalTo: rain.trailingAnchor, constant: inset),
            
            cloudsImg.topAnchor.constraint(equalTo: rain.bottomAnchor, constant: inset),
            cloudsImg.leadingAnchor.constraint(equalTo: time.trailingAnchor, constant: inset),
            clouds.topAnchor.constraint(equalTo: rain.bottomAnchor, constant: inset),
            clouds.leadingAnchor.constraint(equalTo: feelsLike.leadingAnchor),
            cloudsValue.topAnchor.constraint(equalTo: rain.bottomAnchor, constant: inset),
            cloudsValue.leadingAnchor.constraint(equalTo: rainValue.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setTime() {
        if Settings.time == 2 {
            dateFormatter.dateFormat = "hh:mm"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        time.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(weather?.dt ?? 0)))
    }
    
    private func setDate() {
        dateFormatter.dateFormat = "EE, dd/MM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        date.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(weather?.dt ?? 0)))
    }
    
    private func setTemp() {
        temp.text = getProperCurrentTemp(receivedTemp: weather?.main?.temp ?? 0)
        feelsLike.text = getProperCurrentTemp(receivedTemp: weather?.main?.feelsLike ?? 0)
    }
    
    private func setSpeed() {
        if Settings.speed == 1 {
            let speed = ((weather?.wind?.speed ?? 0) * 18) / 5
            windValue.text = String(format: "%.0f", speed) + " Km/h"
        } else {
            windValue.text = String(format: "%.0f", weather?.wind?.speed ?? 0) + " m/s"
        }
    }
}
