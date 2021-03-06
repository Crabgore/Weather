//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Mihail on 08.06.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    lazy var dateFormatter = DateFormatter()
    
    var weather: WeatherList? {
        didSet {
            dateFormatter.dateFormat = "dd/MM"
            date.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(weather?.dt ?? 0)))
            rainPossibility.text = String(format: "%.0f", (weather?.pop ?? 0) * 100) + "%"
            overview.text = getProperDesc(desc: weather?.weather?.first?.weatherDescription ?? "")
            temp.text = getProperMinMaxTemp(receivedMinTemp: weather?.main?.tempMin ?? 0, receivedMaxTemp: weather?.main?.tempMax ?? 0)
        }
    }
    
    private let date: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rain: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rain")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rainPossibility: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overview: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temp: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    private func setupViews() {
        contentView.addSubview(date)
        contentView.addSubview(rain)
        contentView.addSubview(rainPossibility)
        contentView.addSubview(overview)
        contentView.addSubview(temp)
        
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor(rgb: 0xE9EEFA)
        
        let constraints = [
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            rain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            rain.leadingAnchor.constraint(equalTo: date.leadingAnchor),
            rain.widthAnchor.constraint(equalToConstant: 15),
            rain.heightAnchor.constraint(equalToConstant: 15),
            
            rainPossibility.bottomAnchor.constraint(equalTo: rain.bottomAnchor),
            rainPossibility.leadingAnchor.constraint(equalTo: rain.trailingAnchor),
            
            overview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            overview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            overview.leadingAnchor.constraint(equalTo: date.trailingAnchor, constant: 15),
            
            temp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            temp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            temp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
