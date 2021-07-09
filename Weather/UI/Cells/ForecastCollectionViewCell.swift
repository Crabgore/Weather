//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Mihail on 07.06.2021.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    lazy var dateFormatter = DateFormatter()
    
    var weather: WeatherList? {
        didSet {
            let icon = weather?.weather?[0].icon ?? "10d"
            guard let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png"), let data = try? Data(contentsOf: url) else {
                return
            }
            
            myImageView.image = UIImage(data: data)
            setTime()
            setTemp()
        }
    }
    
    private let date: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temp: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(date)
        contentView.addSubview(myImageView)
        contentView.addSubview(temp)
        
        let constraints = [
            date.topAnchor.constraint(equalTo: contentView.topAnchor),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            myImageView.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 5),
            myImageView.leadingAnchor.constraint(equalTo: date.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: date.trailingAnchor),
            myImageView.heightAnchor.constraint(equalTo: myImageView.widthAnchor),
            
            temp.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 5),
            temp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            temp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setTime() {
        if Settings.time == 2 {
            dateFormatter.dateFormat = "dd/MM\nhh:mm"
        } else {
            dateFormatter.dateFormat = "dd/MM\nHH:mm"
        }
        
        date.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(weather?.dt ?? 0)))
    }
    
    private func setTemp() {
        if Settings.temp == 1 {
            let mTemp = ((weather?.main?.temp ?? 0) * 1.8) + 32
            temp.text = String(format: "%.0f", mTemp) + "°"
        } else {
            temp.text = String(format: "%.0f", weather?.main?.temp ?? 0) + "°"
        }
    }
}
