//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mihail on 07.06.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    lazy var dateFormatter = DateFormatter()
    var cityName: String?
    var response: Weather?
    var lists: [WeatherList] = []
    var inspector: RealmInspector?
    var changer: TitleChanger?
    
    @IBOutlet var minMax: UILabel!
    @IBOutlet var currentTemp: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var clouds: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var overview: UILabel!
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var back: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addView: UIView!
    @IBOutlet var HourlyDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        changer?.changeTitle(title: response?.city?.name ?? "")
        setTemp()
        setSpeed()
        collection.reloadData()
        tableView.reloadData()
    }
    
    private func startApp() {
        back.layer.cornerRadius = 5
        setupViews()
        
        guard let mCityName = cityName else {
            return
        }
        
        showInfo(city: mCityName)
    }
    
    private func setupViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toHourlyDetails))
        HourlyDetails.isUserInteractionEnabled = true
        HourlyDetails.addGestureRecognizer(tapGesture)
        
        let attributedString = NSMutableAttributedString.init(string: "Подробнее на 24 часа")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        HourlyDetails.attributedText = attributedString
    }
    
    private func showInfo(city: String) {
        addView.isHidden = true
    
        if let weather = inspector?.getWeather(id: city.lowercased()) {
            setWeatherInfo(result: weather)
        }

        NetworkService.infoDataTask(city: city, block: setInfoFromApi)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Введите название города на английском", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Введите название города на английском"
        }
        let saveAction = UIAlertAction(title: "Сохранить", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields!.first! as UITextField
            if firstTextField.text != nil && !firstTextField.text!.isEmpty {
                self.cityAdded(city: firstTextField.text!)
            }
        })
        
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setWeatherInfo(result: Weather) {
        response = result
        changer?.changeTitle(title: result.city?.name ?? "")
        
        makeList()
        setTemp()
        setSpeed()
        setTime()
        setTextInfo()
        setupCollection()
        setupTableView()
        
        inspector?.saveWeather(response: response, cityId: result.city?.name?.lowercased())
    }
    
    private func setInfoFromApi(json: Data) {
        if let result = try? JSONDecoder().decode(Weather.self, from: json) {
            setWeatherInfo(result: result)
            collection.reloadData()
            tableView.reloadData()
        } else {
            print("BAD RESULT")
        }
    }
    
    private func makeList() {
        lists.removeAll()
        
        guard let list = response?.list, let firstDateInList = list.first else {
            return
        }
        
        lists.append(firstDateInList)
        list.forEach {
            let date = $0.dtTxt ?? ""
            if date.contains("00:00:00") {
                lists.append($0)
            }
        }
    }
    
    private func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection.collectionViewLayout = layout
        collection.dataSource = self
        collection.delegate = self
        collection.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.register(
            ForecastTableViewCell.self,
            forCellReuseIdentifier: String(describing: ForecastTableViewCell.self)
        )
    }
    
    private func setTime() {
        if Settings.time == 2 {
            dateFormatter.dateFormat = "hh:mm"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        sunrise.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(response?.city?.sunrise ?? 0)))
        sunset.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(response?.city?.sunset ?? 0)))
        
        dateFormatter.dateFormat = "EE, dd MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        overview.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(response?.list?.first?.dt ?? 0)))
    }
    
    private func setSpeed() {
        if Settings.speed == 1 {
            let speed = ((response?.list?.first?.wind?.speed ?? 0) * 18) / 5
            windSpeed.text = String(format: "%.0f", speed) + " Km/h"
        } else {
            windSpeed.text = String(format: "%.0f", response?.list?.first?.wind?.speed ?? 0) + " m/s"
        }
    }
    
    private func setTemp() {
        currentTemp.text = getProperCurrentTemp(receivedTemp: response?.list?.first?.main?.temp ?? 0)
        minMax.text = getProperMinMaxTemp(receivedMinTemp: response?.list?.first?.main?.tempMin ?? 0, receivedMaxTemp: response?.list?.first?.main?.tempMax ?? 0)
    }
    
    private func setTextInfo() {
        desc.text = getProperDesc(desc: response?.list?.first?.weather?.first?.weatherDescription ?? "")
        clouds.text = String(response?.list?.first?.clouds?.all ?? 0) + "%"
        humidity.text = String(response?.list?.first?.main?.humidity ?? 0) + "%"
    }
    
    private func cityAdded(city: String) {
        NetworkService.infoDataTask(city: city, block: self.setInfoFromApi)
        self.addView.isHidden = true
        var cities = Settings.city
        cities.append(city)
        Settings.city = cities
    }
    
    func setNewCity(newCityName: String) {
        if cityName == nil {
            cityAdded(city: newCityName)
        }
    }
    
    @objc private func toHourlyDetails() {
        let vc = HourlyViewController()
        vc.list = response?.list
        vc.cityName = response?.city?.name ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ForecastCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ForecastCollectionViewCell
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    var inset: CGFloat { return 2 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let forecastCell = cell as? ForecastCollectionViewCell else { return }
        forecastCell.weather = response?.list?[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedVC")
        (vc as! DetailedViewController).city = response?.city
        (vc as! DetailedViewController).weather = response?.list?[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ForecastTableViewCell.self), for: indexPath) as! ForecastTableViewCell
        cell.weather = lists[indexPath.row]
        return cell
        
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedVC")
        (vc as! DetailedViewController).city = response?.city
        (vc as! DetailedViewController).weather = lists[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
