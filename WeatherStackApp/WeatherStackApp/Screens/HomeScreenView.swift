//
//  HomeScreenViwe.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI

struct HomeScreenView: View {
	
	@StateObject var weatherVM : WeatherViewModel = WeatherViewModel(httpClient: HttpClient())
	
    var body: some View {
		ZStack{
			Color.appTheme.gradientBackground.ignoresSafeArea()
			VStack(alignment:.center){
				
				if weatherVM.isLoading {
					
					ProgressView {
						Text("Loading Weather Info for \(weatherVM.locationRequested) .... ")
							.font(.title2)
							.foregroundStyle(Color.black)
					}
					.accessibilityIdentifier("Loading")
					
				} else if !weatherVM.showError {
					Spacer()
					WeatherInfoView(temperature: weatherVM.temperature,
									windDirection: weatherVM.windDirection,
									region: weatherVM.region,
									locationName: weatherVM.city)
					.accessibilityIdentifier("WeatherInfoView")
					Spacer()
				}
				
			}.task {
				self.weatherVM.fetchWeatherInfo(for: "Mumbai")
			}
			.alert("Error", isPresented: $weatherVM.showError, presenting: weatherVM.errorMessage) { errorMessage in
				Button("Retry", role: .cancel) {
					weatherVM.fetchWeatherInfo(for: "Mumbai")
				
				}
			} message: { errorMessage in
				Text(errorMessage)
			}
		}
    }
}

#Preview {
	HomeScreenView(weatherVM: WeatherViewModel(httpClient: HttpClient()))
}

