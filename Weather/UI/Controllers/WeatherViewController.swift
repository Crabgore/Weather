//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mihail on 07.06.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let dayTimePeriodFormatter = DateFormatter()
    let userDefaults = UserDefaults.standard
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
        
        if cityName == nil {
            let city = userDefaults.string(forKey: CITY)
            if city != nil {
                showInfo(city: city)
            } else {
                return
            }
        } else {
            showInfo(city: cityName)
        }
    }
    
    private func showInfo(city: String?) {
        addView.isHidden = true
    
        let cachedWeather = inspector?.getWeather(id: (city?.lowercased())!)
        if let weather = cachedWeather {
            setWeatherInfo(result: weather)
        }

        NetworkService.infoDataTask(city: city!, block: setInfoFromApi)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Введите название города на английском", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Введите название города на английском"
        }
        let saveAction = UIAlertAction(title: "Сохранить", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text != nil && firstTextField.text != "" {
                NetworkService.infoDataTask(city: firstTextField.text!, block: self.setInfoFromApi)
                self.addView.isHidden = true
                self.userDefaults.setValue(firstTextField.text!, forKey: CITY)
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
        desc.text = result.list?[0].weather?[0].weatherDescription
        clouds.text = String(format: "%.0f", result.list?[0].clouds?.all ?? 0)
        humidity.text = String(result.list?[0].main?.humidity ?? 0) + "%"
        setSpeed()
        
        setTime()
        
        setupCollection()
        setupTableView()
        
        inspector?.saveWeather(weather: response!, id: (result.city?.name?.lowercased())!)
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
        
        lists.append((response?.list?[0])!)
        for i in 0..<response!.list!.count {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let dateAsString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(response?.list?[i].dt ?? 0)))
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "HH"
            let date24 = dateFormatter.string(from: date!)
            if date24 == "02" {
                lists.append((response?.list?[i])!)
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
        tableView.rowHeight = 70
        tableView.register(
            ForecastTableViewCell.self,
            forCellReuseIdentifier: String(describing: ForecastTableViewCell.self)
        )
    }
    
    private func setTime() {
        let timeConfig = userDefaults.integer(forKey: TIME)
        if timeConfig == 2 {
            dayTimePeriodFormatter.dateFormat = "hh:mm"
        } else {
            dayTimePeriodFormatter.dateFormat = "HH:mm"
        }
        
        sunrise.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: Double(response?.city?.sunrise ?? 0)))
        sunset.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: Double(response?.city?.sunset ?? 0)))
    }
    
    private func setSpeed() {
        let timeConfig = userDefaults.integer(forKey: SPEED)
        if timeConfig == 1 {
            let speed = ((response?.list?[0].wind?.speed ?? 0) * 18) / 5
            windSpeed.text = String(format: "%.0f", speed) + " Km/h"
        } else {
            windSpeed.text = String(format: "%.0f", response?.list?[0].wind?.speed ?? 0) + " m/s"
        }
    }
    
    private func setTemp() {
        let tempConfig = userDefaults.integer(forKey: TEMP)
        if tempConfig == 1 {
            let minTemp = ((response?.list?[0].main?.tempMin ?? 0) * 1.8) + 32
            let maxTemp = ((response?.list?[0].main?.tempMax ?? 0) * 1.8) + 32
            let temp = ((response?.list?[0].main?.temp ?? 0) * 1.8) + 32
            minMax.text = String(format: "%.0f", minTemp) + "°/" + String(format: "%.0f", maxTemp) + "°"
            currentTemp.text = String(format: "%.0f", temp) + "°"
        } else {
            minMax.text = String(format: "%.0f", response?.list?[0].main?.tempMin ?? 0) + "°/" + String(format: "%.0f", response?.list?[0].main?.tempMax ?? 0) + "°"
            currentTemp.text = String(format: "%.0f", response?.list?[0].main?.temp ?? 0) + "°"
        }
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
        return CGSize(width: (collectionView.frame.width - inset * 4) / 7, height: (collectionView.frame.width - inset * 4) / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.greatestFiniteMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let forecastCell = cell as? ForecastCollectionViewCell else { return }
        forecastCell.weather = response?.list?[indexPath.item]
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

protocol TitleChanger {
    func changeTitle(title: String)
}
