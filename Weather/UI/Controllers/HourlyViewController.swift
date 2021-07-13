//
//  HourlyViewController.swift
//  Weather
//
//  Created by Mihail on 24.06.2021.
//

import UIKit
import Charts

class HourlyViewController: UIViewController {
    var list: [WeatherList]?
    var cityName: String? {
        didSet {
            temp.text = cityName
        }
    }
    
    var tempChartsList = [ChartDataEntry]()
    var rainChartsList = [ChartDataEntry]()
    var myList = [WeatherList]()
    var dateList = [CLong]()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var tempLineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = UIColor(rgb: 0xE9EEFA)
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    lazy var rainLineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = UIColor(rgb: 0xE9EEFA)
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
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
        setupTempChartData()
        setupRainChartData()
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
        view.addSubviews(temp, tempLineChartView, rainLineChartView, tableView)
        
        let constraints = [
            temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            temp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
            tempLineChartView.topAnchor.constraint(equalTo: temp.bottomAnchor, constant: 5),
            tempLineChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tempLineChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tempLineChartView.heightAnchor.constraint(equalToConstant: 100),
            
            rainLineChartView.topAnchor.constraint(equalTo: tempLineChartView.bottomAnchor),
            rainLineChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            rainLineChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            rainLineChartView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: rainLineChartView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func makeList() {
        var count = 0.0
        
        for i in 0...8 {
            if let item = list?[i] {
                tempChartsList.append(ChartDataEntry(x: count, y: item.main?.temp ?? 0))
                rainChartsList.append(ChartDataEntry(x: count, y: (item.pop ?? 0) * 100, icon: UIImage(color: UIColor(rgb: 0x204EC7), size: CGSize(width: 1, height: 2))))
                dateList.append(item.dt ?? 0)
                myList.append(item)
                count += 1
            }
        }
    }
    
    private func setupTempChartData() {
        let gradientColors = [UIColor(rgb: 0x204EC7).cgColor, UIColor(rgb: 0xE9EEFA).cgColor] as CFArray
        let colorLocation: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocation) else {
            return
        }
        
        let set = LineChartDataSet(entries: tempChartsList)
        set.setColor(UIColor(rgb: 0x204EC7))
        set.setCircleColor(.white)
        set.circleHoleColor = .white
        set.circleRadius = 2
        set.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        set.drawFilledEnabled = true
        tempLineChartView.xAxis.drawGridLinesEnabled = false
        tempLineChartView.chartDescription?.enabled = false
        tempLineChartView.legend.enabled = false
        
        let data = LineChartData(dataSet: set)
        let tempFormatter = TempLabelFormatter()
        data.dataSets.first?.valueFormatter = tempFormatter
        data.dataSets.first?.valueFont = UIFont.systemFont(ofSize: 10)
        
        tempLineChartView.data = data
    }
    
    private func setupRainChartData() {
        let set = LineChartDataSet(entries: rainChartsList)
        set.setColor(UIColor(rgb: 0x204EC7))
        set.drawCirclesEnabled = false
        
        let formatter = ChartFormatter()
        formatter.setValues(entries: dateList)
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        rainLineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        rainLineChartView.xAxis.drawGridLinesEnabled = false
        rainLineChartView.chartDescription?.enabled = false
        rainLineChartView.legend.enabled = false
        
        let data = LineChartData(dataSet: set)
        let rainFormatter = RainLabelFormatter()
        data.dataSets.first?.valueFormatter = rainFormatter
        data.dataSets.first?.valueFont = UIFont.systemFont(ofSize: 10)
        
        rainLineChartView.data = data
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
