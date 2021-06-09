//
//  NetworkService.swift
//  Weather
//
//  Created by Mihail on 07.06.2021.
//

import Foundation

struct NetworkService {
    private static let apiKey = "038a5a9df7a559719f7f6be0a27c70d2"
    private static let session = URLSession.shared
    
    static func infoDataTask(city: String, block: @escaping (Data) -> Void) {
        let cityName = city.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&units=metric&appid=\(apiKey)")
        
        let task = session.dataTask(with: url!) { data, response, error in

            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return }
            
            guard let info = data else { return }
            
            if let result = String(data: info, encoding: .utf8) {
                print(result)
            }
            
            DispatchQueue.main.async {
                block(info)
            }
        }
        
        task.resume()
    }
    
    
    
}
