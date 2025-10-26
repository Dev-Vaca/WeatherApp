//
//  ApiNetwork.swift
//  WeatherApp
//
//  Created by Julio César Vaca García on 24/10/25.
//

import Foundation

class ApiNetwork {
    
    struct Weather: Codable {
        let location: Location
        let current: Current
        let forecast: Forecast
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastDay]
    }
    
    struct ForecastDay: Codable, Identifiable {
        var id: String { date }
        let date: String
        let day: Day
        let astro: Astro
    }
    
    struct Astro: Codable {
        let sunrise: String
        let sunset: String
        let moonrise: String
        let moonset: String
        let moonPhase: String
        let isMoonUp: Int
        let isSunUp: Int
            
        enum CodingKeys: String, CodingKey {
            case sunrise, sunset, moonrise, moonset
            case moonPhase = "moon_phase"
            case isMoonUp = "is_moon_up"
            case isSunUp = "is_sun_up"
        }
    }
    
    struct Day: Codable {
        let maxTempC: Double
        let minTempC: Double
        let maxWindKph: Double
        let willItRain: Int
        let chanceOfRain: Int
        let willItSnow: Int
        let chanceOfSnow: Int
        let condition: Condition
            
        enum CodingKeys: String, CodingKey {
            case maxTempC = "maxtemp_c"
            case minTempC = "mintemp_c"
            case maxWindKph = "maxwind_kph"
            case willItRain = "daily_will_it_rain"
            case chanceOfRain = "daily_chance_of_rain"
            case willItSnow = "daily_will_it_snow"
            case chanceOfSnow = "daily_chance_of_snow"
            case condition
        }
    }
    
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let localtime: String
    }
    
    struct Current: Codable {
        let tempC: Double
        let condition: Condition
        let windKph: Double
        let feelslikeC: Double
            
        enum CodingKeys: String, CodingKey {
            case tempC = "temp_c"
            case condition
            case windKph = "wind_kph"
            case feelslikeC = "feelslike_c"
        }
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
    }
    
    func getWeatherByQuery(query: String) async throws -> Weather {
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=a3c31fe6c35c47ed957214428252410&q=\(query)&days=7&aqi=no&alerts=no")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Weather.self, from: data)
    }
    
    struct CitySuggestion: Codable, Identifiable {
        let id: Int
        let name: String
        let region: String
        let country: String
    }
        
    func getCitySuggestions(query: String) async throws -> [CitySuggestion] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=a3c31fe6c35c47ed957214428252410&q=\(encoded)") else {
            return []
        }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([CitySuggestion].self, from: data)
    }
}
