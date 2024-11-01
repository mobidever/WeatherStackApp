//
//  WeatherViewModel.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI
import Combine

class WeatherViewModel : ObservableObject {
	
	@Published var temperature: String = "--"
	@Published var city: String = "--"
	@Published var region: String = "--"
	@Published var windDirection: String = "--"
	@Published var windSpeed : String = "--"
	
	@Published var isLoading: Bool = true
	@Published var showError: Bool = false
	@Published var errorMessage: String?
	
	private var weatherModelCancellable = Set<AnyCancellable>()
	@Published var searchText = ""
	private let httpClient: NetworkClient
	
//	init() {
//		self.fetchWeatherInfo()
//	}
	
	init(httpClient: NetworkClient){
		self.httpClient = httpClient
		
	}
	
	func temperatureFormatInDegrees(weatherInfo: CurrentWeatherInfo) -> String {
		return "\(weatherInfo.temperature)°C"
	}
	
	/*
	 Method to return weatherInfoPublisher, which takes input as json
	 */
	func weatherPublisher(for location:String) -> AnyPublisher<Data,Error> {
		
		self.httpClient.fetchData(from: Urls.weatherInfoURL(for: "Mumbai"))
			.receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}

	func fetchWeatherInfo() {

		self.isLoading = true
		
		self.weatherPublisher(for: "Mumbai")
					.decode(type: WeatherModel.self, decoder: JSONDecoder())
					.sink(receiveCompletion: { [weak self] (completion) in
						self?.isLoading = false
						switch completion {
							case .finished:
								print("Call invoke Finished")
							case .failure(let error):
								self?.showError = true
								self?.errorMessage = error.localizedDescription
								print("Call invoke Failed with error: \(error.localizedDescription)")
						}
						
					}, receiveValue: { [weak self] (weatherModel) in
						
						self?.isLoading = false
						print(weatherModel.location.name)
						self?.temperature = self?.temperatureFormatInDegrees(weatherInfo: weatherModel.current) ?? "Unknown"
						self?.city = weatherModel.location.name
						self?.region = weatherModel.location.region
						self?.windDirection =  "\(weatherModel.current.wind_dir)"
						
					}).store(in: &weatherModelCancellable)
		
	}
	
}

