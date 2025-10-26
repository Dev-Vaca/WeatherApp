//
//  DetailView.swift
//  WeatherApp
//
//  Created by Julio César Vaca García on 25/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    let cityName: String
    @State private var weather: ApiNetwork.Weather? = nil
    @State private var loading = true
    
    var body: some View {
        ZStack {
            // Fondo degradado dinámico
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.9),
                    Color(red: 0.4, green: 0.2, blue: 0.8),
                    Color(red: 0.6, green: 0.3, blue: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if loading {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("loading-key")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            } else if let weather = weather {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 8) {
                            Text(weather.location.name)
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                            Text(weather.location.country)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.85))
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.caption)
                                Text(weather.location.localtime)
                                    .font(.callout)
                            }
                            .foregroundColor(.white.opacity(0.75))
                        }
                        .padding(.top, 40)
                        
                        // ☀️ Clima actual - Card principal
                        VStack(spacing: 8) {
                            WebImage(url: URL(string: "https:" + weather.current.condition.icon))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .shadow(color: .black.opacity(0.3), radius: 10)
                            
                            Text("\(Int(weather.current.tempC))°")
                                .font(.system(size: 80, weight: .thin))
                                .foregroundColor(.white)
                            
                            Text(weather.current.condition.text)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            // Sensación térmica destacada
                            Text("\(Text("feels-like-key")) \(Int(weather.current.feelslikeC))°")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 15, y: 5)
                        )
                        .padding(.horizontal, 20)
                        
                        // Grid de información actual
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            WeatherInfoCard(
                                icon: "wind",
                                title: "title-wind-key",
                                value: "\(Int(weather.current.windKph)) km/h",
                                color: .cyan
                            )
                            
                            WeatherInfoCard(
                                icon: "thermometer.medium",
                                title: "title-sensitive-key",
                                value: "\(Int(weather.current.feelslikeC))°C",
                                color: .orange
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // 🌅 Información astronómica
                        if let today = weather.forecast.forecastday.first {
                            VStack(spacing: 16) {
                                Text("solar-lunar-info-key")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                
                                // Sol
                                HStack(spacing: 20) {
                                    AstroInfoItem(
                                        icon: "sunrise.fill",
                                        label: "sunrise-key",
                                        value: today.astro.sunrise,
                                        color: .orange
                                    )
                                    
                                    Divider()
                                        .frame(height: 40)
                                        .background(Color.white.opacity(0.3))
                                    
                                    AstroInfoItem(
                                        icon: "sunset.fill",
                                        label: "sunset-key",
                                        value: today.astro.sunset,
                                        color: .pink
                                    )
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.ultraThinMaterial)
                                )
                                .padding(.horizontal, 20)
                                
                                // Luna
                                HStack(spacing: 20) {
                                    AstroInfoItem(
                                        icon: "moonrise.fill",
                                        label: "moonrise-key",
                                        value: today.astro.moonrise,
                                        color: .indigo
                                    )
                                    
                                    Divider()
                                        .frame(height: 40)
                                        .background(Color.white.opacity(0.3))
                                    
                                    AstroInfoItem(
                                        icon: "moonset.fill",
                                        label: "moonset-key",
                                        value: today.astro.moonset,
                                        color: .purple
                                    )
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.ultraThinMaterial)
                                )
                                .padding(.horizontal, 20)
                                
                                // Fase lunar
                                HStack(spacing: 12) {
                                    Image(systemName: moonPhaseIcon(today.astro.moonPhase))
                                        .font(.title)
                                        .foregroundColor(.yellow)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("moon-phase-key")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                        Text(today.astro.moonPhase)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    // Estado actual
                                    HStack(spacing: 16) {
                                        VStack(spacing: 4) {
                                            Image(systemName: today.astro.isSunUp == 1 ? "sun.max.fill" : "moon.stars.fill")
                                                .foregroundColor(today.astro.isSunUp == 1 ? .yellow : .indigo)
                                            Text(today.astro.isSunUp == 1 ? "day-key" : "night-key")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        
                                        VStack(spacing: 4) {
                                            Image(systemName: today.astro.isMoonUp == 1 ? "moon.fill" : "moon.zzz.fill")
                                                .foregroundColor(.purple)
                                            Text(today.astro.isMoonUp == 1 ? "visible-key" : "hidden-key")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.ultraThinMaterial)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // 📆 Pronóstico 7 días mejorado
                        VStack(alignment: .leading, spacing: 16) {
                            Text("forecast-7-days-key")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ForEach(weather.forecast.forecastday) { day in
                                ForecastDayCard(forecastDay: day)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text("error-loading-key")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
        }
        .task {
            do {
                weather = try await ApiNetwork().getWeatherByQuery(query: cityName)
            } catch {
                print("Error al cargar clima:", error)
                weather = nil
            }
            loading = false
        }
    }
    
    // 🌙 Obtener ícono de fase lunar
    func moonPhaseIcon(_ phase: String) -> String {
        let lowercased = phase.lowercased()
        if lowercased.contains("new") {
            return "moonphase.new.moon"
        } else if lowercased.contains("full") {
            return "moonphase.full.moon"
        } else if lowercased.contains("first quarter") {
            return "moonphase.first.quarter"
        } else if lowercased.contains("last quarter") {
            return "moonphase.last.quarter"
        } else if lowercased.contains("waxing crescent") {
            return "moonphase.waxing.crescent"
        } else if lowercased.contains("waxing gibbous") {
            return "moonphase.waxing.gibbous"
        } else if lowercased.contains("waning crescent") {
            return "moonphase.waning.crescent"
        } else if lowercased.contains("waning gibbous") {
            return "moonphase.waning.gibbous"
        }
        return "moon.fill"
    }
    
    // 🔤 Formateador de fecha
    func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "es_MX")
            outputFormatter.dateFormat = "E d MMM"
            return outputFormatter.string(from: date).capitalized
        }
        return dateString
    }
}

struct WeatherInfoCard: View {
    let icon: String
    let title: LocalizedStringKey
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.title3.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        )
    }
}

struct AstroInfoItem: View {
    let icon: String
    let label: LocalizedStringKey
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ForecastDayCard: View {
    let forecastDay: ApiNetwork.ForecastDay
    
    var body: some View {
        VStack(spacing: 12) {
            // Encabezado del día
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedDate(forecastDay.date))
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(forecastDay.day.condition.text)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                WebImage(url: URL(string: "https:" + forecastDay.day.condition.icon))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text("\(Int(forecastDay.day.maxTempC))°")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(width: 50, alignment: .trailing)
                
                Text("\(Int(forecastDay.day.minTempC))°")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 50, alignment: .trailing)
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Detalles adicionales
            HStack(spacing: 16) {
                // Viento
                HStack(spacing: 6) {
                    Image(systemName: "wind")
                        .foregroundColor(.cyan)
                    Text("\(Int(forecastDay.day.maxWindKph)) km/h")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                // Probabilidad de lluvia
                if forecastDay.day.chanceOfRain > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                        Text("\(forecastDay.day.chanceOfRain)%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                
                // Probabilidad de nieve
                if forecastDay.day.chanceOfSnow > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "snowflake")
                            .foregroundColor(.white)
                        Text("\(forecastDay.day.chanceOfSnow)%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        )
        .padding(.horizontal, 20)
    }
    
    func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "es_MX")
            outputFormatter.dateFormat = "EEEE d 'de' MMMM"
            return outputFormatter.string(from: date).capitalized
        }
        return dateString
    }
}

#Preview {
    DetailView(cityName: "London")
}
