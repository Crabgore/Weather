//
//  HourlyViewController.swift
//  Weather
//
//  Created by Mihail on 24.06.2021.
//

import UIKit

class HourlyViewController: UIViewController {
    var list: [WeatherList]?
    var cityName: String? {
        didSet {
            temp.text = cityName
        }
    }
    
    
    lazy var dateFormatter = DateFormatter()
    var myList = [WeatherList]()
    var previousTemp = 0.0
    var previousRain = 0.0
    var previousTempPoint = CGPoint(x: 0, y: 0)
    var previousRainPoint = CGPoint(x: 0, y: 0)
    var myX = 10
    var counter = 0
    var implementer = 10
    let RAIN = "rain"
    let TEMP = "temp"
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let tempGraphView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xE9EEFA)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let temp: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        makeList()
        setupTableView()
        setupViews()
        makeTempGraph()
        makeRainGraph()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.register(
            HourlyTableViewCell.self,
            forCellReuseIdentifier: String(describing: HourlyTableViewCell.self)
        )
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(temp, tempGraphView, tableView)
        counter = Int((view.viewWidth - 10) / 9)
        
        let constraints = [
            temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            temp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
            tempGraphView.topAnchor.constraint(equalTo: temp.bottomAnchor, constant: 5),
            tempGraphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tempGraphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tempGraphView.heightAnchor.constraint(equalToConstant: 240),
            
            tableView.topAnchor.constraint(equalTo: tempGraphView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func makeList() {
        myList.removeAll()
        
        
        //путём экспериментов выявлено, что такое количество точек оптимально для всех экранов
        for i in 0...8 {
            if let item = list?[i] {
                myList.append(item)
            }
        }
    }

    private func makeTempGraph() {
        let path = UIBezierPath()
        let point = makeFirstPoint()
        
        path.move(to: point)
        
        if let temp = myList.first?.main?.temp {
            addTempPoint(point: point, temp: temp)
        }
        if let time = myList.first?.dt {
            setTime(x: Int(point.x), view: tempGraphView, time: time)
        }
        
        //здесь необходимо начинать отсчёт со второго элемента
        for i in 1..<myList.count {
            if let temp = myList[i].main?.temp, let time = myList[i].dt {
                path.addLine(to: makeDot(x: myX, temp: temp, time: time))
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1

        tempGraphView.layer.addSublayer(shapeLayer)
        
        myX = 10
    }
    
    private func makeRainGraph() {
        let path = UIBezierPath()
        let point = CGPoint(x: 10, y: 170)
        let rain = myList.first?.pop ?? 0
        let icon = myList.first?.weather?.first?.icon ?? "10d"
        
        path.move(to: point)
        
        addRainPoint(point: point, rain: rain, icon: icon)
        
        //здесь необходимо начинать отсчёт со второго элемента
        for i in 1..<myList.count {
            if let time = myList[i].dt {
                path.addLine(to: makeRainDot(x: myX, rain: myList[i].pop ?? 0, time: time, icon: icon))
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1

        tempGraphView.layer.addSublayer(shapeLayer)
    }
    
    private func makeDot(x: Int, temp: Double, time: CLong) -> CGPoint {
        var result = CGPoint(x: 0, y: 0)
        if temp > previousTemp {
            let y = Int(Double(Int(previousTempPoint.y)) - ((temp - previousTemp) * 2))
            result = CGPoint(x: x, y: y)
        } else {
            let y = Int(Double(Int(previousTempPoint.y)) + ((previousTemp - temp) * 2))
            result = CGPoint(x: x, y: y)
        }
        
        addTempPoint(point: result, temp: temp)
        setTime(x: Int(result.x), view: tempGraphView, time: time)
        
        return result
    }
    
    private func makeRainDot(x: Int, rain: Double, time: CLong, icon: String) -> CGPoint {
        var result = CGPoint(x: 0, y: 0)
        if rain > previousRain {
            let y = Int(Double(Int(previousRainPoint.y)) - ((rain - previousRain) * 10))
            result = CGPoint(x: x, y: y)
        } else {
            let y = Int(Double(Int(previousRainPoint.y)) + ((previousRain - rain) * 10))
            result = CGPoint(x: x, y: y)
        }
        
        addRainPoint(point: result, rain: rain, icon: icon)
        
        return result
    }
    
    private func addTempPoint(point: CGPoint, temp: Double) {
        previousTempPoint = point
        previousTemp = temp
        myX += counter
        
        let label = UILabel()
        label.text = String(Int(temp)) + "°"
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: point.x, y: point.y - 25, width: 30, height: 25)
        tempGraphView.addSubview(label)
        
        addDotToGraph(point: point, type: TEMP)
    }
    
    private func addRainPoint(point: CGPoint, rain: Double, icon: String) {
        previousRainPoint = point
        previousRain = rain
        myX += counter
        
        let label = UILabel()
        label.text = String(format: "%.0f", rain * 100) + "%"
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: point.x - 10, y: point.y - 30, width: 50, height: 25)
        tempGraphView.addSubview(label)
        
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png"), let data = try? Data(contentsOf: url) else {
            return
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: point.x - 10, y: point.y - 50, width: 25, height: 25)
        imageView.image = UIImage(data: data)
        tempGraphView.addSubview(imageView)
        
        addDotToGraph(point: point, type: RAIN)
    }
    
    private func addDotToGraph(point: CGPoint, type: String) {
        let firstDotView = UIView()
        if type == TEMP {
            firstDotView.frame = CGRect(x: point.x-5, y: point.y-5, width: 10, height: 10)
            firstDotView.layer.cornerRadius = 10
        } else {
            firstDotView.frame = CGRect(x: point.x-3, y: point.y-5, width: 5, height: 10)
        }
        firstDotView.backgroundColor = .blue
        tempGraphView.addSubview(firstDotView)
    }
    
    private func setTime(x: Int, view: UIView, time: CLong) {
        if Settings.time == 2 {
            dateFormatter.dateFormat = "hh:mm"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(time)))
        label.frame = CGRect(x: x - 5, y: 220, width: 30, height: 25)
        view.addSubview(label)
    }
    
    private func makeFirstPoint() -> CGPoint {
        let temps = myList.map { ($0.main?.temp ?? 0.0) }
        let hottest = temps.max() ?? 1000.0
        let coldest = temps.min() ?? -236
        
        var result = CGPoint(x: 0, y: 0)
        if hottest > 0 && coldest > 0 {
            result = CGPoint(x: 10, y: 75)
        } else {
            result = CGPoint(x: 10, y: 25)
        }
        
        return result
    }
}

extension HourlyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HourlyTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HourlyTableViewCell.self), for: indexPath) as! HourlyTableViewCell
        cell.weather = myList[indexPath.row]
        return cell
    }
}
