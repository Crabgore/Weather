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
        weatherList.forEach { item in
            let list = CachedList()
            list.dt.value = item.dt
            
            let main = CachedMain()
            main.id = UUID().uuidString
            main.feelsLike.value = item.main?.feelsLike
            main.grndLevel.value = item.main?.grndLevel
            main.humidity.value = item.main?.humidity
            main.pressure.value = item.main?.pressure
            main.seaLevel.value = item.main?.seaLevel
            main.temp.value = item.main?.temp
            main.tempKf.value = item.main?.tempKf
            main.tempMax.value = item.main?.tempMax
            main.tempMin.value = item.main?.tempMin
            list.main = main
            
            let elements = List<CachedWeatherElement>()
            if let weatherListElemet = item.weather {
                weatherListElemet.forEach { weather in
                    let element = CachedWeatherElement()
                    element.icon = weather.icon
                    element.id.value = weather.id
                    element.main = weather.main
                    element.weatherDescription = weather.weatherDescription
                    elements.append(element)
                }
            }
        
            list.weather = elements
            
            let clouds = CachedClouds()
            clouds.all.value = item.clouds?.all
            list.clouds = clouds
            
            let wind = CachedWind()
            wind.deg.value = item.wind?.deg
            wind.gust.value = item.wind?.gust
            wind.speed.value = item.wind?.speed
            list.wind = wind
            
            list.visibility.value = item.visibility
            list.pop.value = item.pop
            
            let rain = CachedRain()
            rain.the3H.value = item.rain?.the3H
            list.rain = rain
            
            let sys = CachedSys()
            sys.pod = item.sys?.pod
            list.sys = sys
            list.dtTxt = item.dtTxt
            
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
            list.forEach { item in
                let dt = item.dt
                let main = Main(temp: item.main?.temp.value, feelsLike: item.main?.feelsLike.value, tempMin: item.main?.tempMin.value, tempMax: item.main?.tempMax.value, pressure: item.main?.pressure.value, seaLevel: item.main?.pressure.value, grndLevel: item.main?.grndLevel.value, humidity: item.main?.grndLevel.value, tempKf: item.main?.tempKf.value)
                var elements = [WeatherElement]()
                item.weather.forEach { weather in
                    let element = WeatherElement(id: weather.id.value, main: weather.main, weatherDescription: weather.weatherDescription, icon: weather.icon)
                    elements.append(element)
                }
                let clouds = Clouds(all: item.clouds?.all.value)
                let wind = Wind(speed: item.wind?.speed.value, deg: item.wind?.deg.value, gust: item.wind?.gust.value)
                let visibility = item.visibility
                let pop = item.pop
                let rain = Rain(the3H: item.rain?.the3H.value)
                let sys = Sys(pod: item.sys?.pod)
                let dtTxt = item.dtTxt
                
                mList.append(WeatherList(dt: dt.value, main: main, weather: elements, clouds: clouds, wind: wind, visibility: visibility.value, pop: pop.value, rain: rain, sys: sys, dtTxt: dtTxt))
            }
            
            let mCity = City(id: city?.id.value, name: city?.name, coord: Coord(lat: city?.coord?.lat.value, lon: city?.coord?.lon.value), country: city?.country, timezone: city?.timezone.value, sunrise: city?.sunrise.value, sunset: city?.sunset.value)
            
            return Weather(cod: cod, message: message.value, cnt: cnt.value, list: mList, city: mCity)
        }
        
        return nil
    }
}
