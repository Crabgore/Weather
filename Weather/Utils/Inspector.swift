//
//  Inspector.swift
//  Weather
//
//  Created by Mihail on 08.06.2021.
//

import Foundation
import RealmSwift

class Inspector: RealmInspector {
   private var realm: Realm? {
        return try? Realm()
    }
    
    func saveWeather(response: Weather?, cityId: String?) {
        guard let weather = response, let id = cityId, let weatherList = weather.list else {
            return
        }
        
        let mWeather = CachedWeather()
        mWeather.id = id
        mWeather.cod = weather.cod
        mWeather.message.value = weather.message
        mWeather.cnt.value = weather.cnt
        
        let mList = List<CachedList>()
        for i in 0..<weatherList.count {
            let list = CachedList()
            list.dt.value = weatherList[i].dt
            
            let main = CachedMain()
            main.id = UUID().uuidString
            main.feelsLike.value = weatherList[i].main?.feelsLike
            main.grndLevel.value = weatherList[i].main?.grndLevel
            main.humidity.value = weatherList[i].main?.humidity
            main.pressure.value = weatherList[i].main?.pressure
            main.seaLevel.value = weatherList[i].main?.seaLevel
            main.temp.value = weatherList[i].main?.temp
            main.tempKf.value = weatherList[i].main?.tempKf
            main.tempMax.value = weatherList[i].main?.tempMax
            main.tempMin.value = weatherList[i].main?.tempMin
            list.main = main
            
            let elements = List<CachedWeatherElement>()
            if let weatherListElemet = weatherList[i].weather {
                for j in 0..<weatherListElemet.count {
                    let element = CachedWeatherElement()
                    element.icon = weatherListElemet[j].icon
                    element.id.value = weatherListElemet[j].id
                    element.main = weatherListElemet[j].main
                    element.weatherDescription = weatherListElemet[j].weatherDescription
                    elements.append(element)
                }
            }
        
            list.weather = elements
            
            let clouds = CachedClouds()
            clouds.all.value = weatherList[i].clouds?.all
            list.clouds = clouds
            
            let wind = CachedWind()
            wind.deg.value = weatherList[i].wind?.deg
            wind.gust.value = weatherList[i].wind?.gust
            wind.speed.value = weatherList[i].wind?.speed
            list.wind = wind
            
            list.visibility.value = weatherList[i].visibility
            list.pop.value = weatherList[i].pop
            
            let rain = CachedRain()
            rain.the3H.value = weatherList[i].rain?.the3H
            list.rain = rain
            
            let sys = CachedSys()
            sys.pod = weatherList[i].sys?.pod
            list.sys = sys
            list.dtTxt = weatherList[i].dtTxt
            
            mList.append(list)
        }
        mWeather.list = mList
        
        let city = CachedCity()
        
        let coord = CachedCoord()
        coord.lat.value = weather.city?.coord?.lat
        coord.lon.value = weather.city?.coord?.lon
        city.coord = coord
        
        city.country = weather.city?.country
        city.id.value = weather.city?.id
        city.name = weather.city?.name
        city.sunrise.value = weather.city?.sunrise
        city.sunset.value = weather.city?.sunset
        city.timezone.value = weather.city?.timezone
        
        mWeather.city = city
        
        try! realm?.write {
            realm?.add(mWeather, update: .all)
        }
    }
    
    func getWeather(id: String) -> Weather? {
        if let response = realm?.object(ofType: CachedWeather.self, forPrimaryKey: id) {
            let cod = response.cod
            let message = response.message
            let cnt = response.cnt
            let city = response.city
            let list = response.list

            var mList = [WeatherList]()
            for i in 0..<list.count {
                let dt = list[i].dt
                let main = Main(temp: list[i].main?.temp.value, feelsLike: list[i].main?.feelsLike.value, tempMin: list[i].main?.tempMin.value, tempMax: list[i].main?.tempMax.value, pressure: list[i].main?.pressure.value, seaLevel: list[i].main?.pressure.value, grndLevel: list[i].main?.grndLevel.value, humidity: list[i].main?.grndLevel.value, tempKf: list[i].main?.tempKf.value)
                var elements = [WeatherElement]()
                for j in 0..<list[i].weather.count {
                    let element = WeatherElement(id: list[i].weather[j].id.value, main: list[i].weather[j].main, weatherDescription: list[i].weather[j].weatherDescription, icon: list[i].weather[j].icon)
                    elements.append(element)
                }
                let clouds = Clouds(all: list[i].clouds?.all.value)
                let wind = Wind(speed: list[i].wind?.speed.value, deg: list[i].wind?.deg.value, gust: list[i].wind?.gust.value)
                let visibility = list[i].visibility
                let pop = list[i].pop
                let rain = Rain(the3H: list[i].rain?.the3H.value)
                let sys = Sys(pod: list[i].sys?.pod)
                let dtTxt = list[i].dtTxt
                
                mList.append(WeatherList(dt: dt.value, main: main, weather: elements, clouds: clouds, wind: wind, visibility: visibility.value, pop: pop.value, rain: rain, sys: sys, dtTxt: dtTxt))
            }
            
            let mCity = City(id: city?.id.value, name: city?.name, coord: Coord(lat: city?.coord?.lat.value, lon: city?.coord?.lon.value), country: city?.country, timezone: city?.timezone.value, sunrise: city?.sunrise.value, sunset: city?.sunset.value)
            
            return Weather(cod: cod, message: message.value, cnt: cnt.value, list: mList, city: mCity)
        }
        
        return nil
    }

}
