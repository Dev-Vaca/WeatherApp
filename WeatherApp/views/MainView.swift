//
//  MainView.swift
//  WeatherApp
//
//  Created by Julio César Vaca García on 24/10/25.
//

import SwiftUI

struct MainView: View {
    @State private var city: String = ""
    @State private var suggestions: [ApiNetwork.CitySuggestion] = []
    @State private var loading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("title-app-key")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                        .shadow(radius: 4)
                    
                    TextField("search-query-key", text: $city)
                        .font(.title2)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                        .autocorrectionDisabled()
                        .onChange(of: city) {
                            Task { await fetchSuggestions(for: city) }
                        }
                    
                    if loading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                            .padding()
                    }
                    
                    if !suggestions.isEmpty && city.count > 1 {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(suggestions.prefix(6)) { suggestion in
                                    NavigationLink {
                                        DetailView(cityName: suggestion.name)
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(suggestion.name)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                Text("\(suggestion.region), \(suggestion.country)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                            Spacer()
                                            Image(systemName: "arrow.right.circle.fill")
                                                .foregroundColor(.white)
                                                .font(.title3)
                                        }
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.purple.opacity(0.6), .blue.opacity(0.6)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(radius: 4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    if !loading && city.isEmpty && suggestions.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "cloud.sun.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                                .shadow(radius: 6)
                            Text("example-text-key")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.headline)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func fetchSuggestions(for query: String) async {
        guard query.count > 1 else {
            suggestions.removeAll()
            return
        }
        loading = true
        do {
            suggestions = try await ApiNetwork().getCitySuggestions(query: query)
        } catch {
            print("Error fetching suggestions:", error)
        }
        loading = false
    }
}

#Preview {
    MainView()
}
