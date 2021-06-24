//
//  HourlyViewController.swift
//  Weather
//
//  Created by Mihail on 24.06.2021.
//

import UIKit

class HourlyViewController: UIViewController {
    
    var list: [WeatherList]?
    var myList = [WeatherList]()
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        makeList()
        setupTableView()
        setupViews()
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
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func makeList() {
        myList.removeAll()
        for i in 0...8 {
            myList.append((list?[i])!)
        }
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
