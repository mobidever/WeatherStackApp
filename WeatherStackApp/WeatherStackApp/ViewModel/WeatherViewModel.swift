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
	
	@Published var locationRequested : String = ""
	
	@Published var isLoading: Bool = true
	@Published var showError: Bool = false
	@Published var errorMessage: String?
	
	private var weatherModelCancellable = Set<AnyCancellable>()
	private let httpClient: NetworkClient

	/*
	 Initialize ViewModel with NetworkClient protocol.
	 */
	init(httpClient: NetworkClient){
		self.httpClient = httpClient
	}
	
	/*
	 Returns the Formatted Temperature in °Centigrade unit
	 */
	func temperatureFormatInDegrees(weatherInfo: CurrentWeatherInfo) -> String {
		return "\(weatherInfo.temperature)°C"
	}
	
	/*
	 Returns weatherInfoPublisher, which emits Data,Error
	 */
	func weatherPublisher(for location:String) -> AnyPublisher<Data,Error> {
		self.locationRequested = location
		return self.httpClient.fetchData(from: Urls.weatherInfoURL(for: location))
			.receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}

	/*
	Method to fetch Weather information, based on the mock environment and real time environment.
	 */
	func fetchWeatherInfo(for location:String) {
		self.isLoading = true

		#if DEBUG
			if ProcessInfo.processInfo.arguments.contains("MOCK_VIEWMODEL_DATA_LOADED") {
				self.isLoading = false
				self.city = "Mumbai"
				self.region = "Maharasthra"
				let mockWeatherInfo = CurrentWeatherInfo(temperature: 24, wind_dir: "SE", wind_degree: 25)
				self.temperature = self.temperatureFormatInDegrees(weatherInfo: mockWeatherInfo)
				self.windDirection = "SE"
				return
			}else if ProcessInfo.processInfo.arguments.contains("MOCK_VIEWMODEL_DATA_LOADING_FAILURE") {
				
				Fail<WeatherModel, Error>(error: URLError(.badServerResponse))
					.delay(for: .seconds(1), scheduler: RunLoop.main) // lets say there is a delay in  loading due to low network signal
					.sink(receiveCompletion: { [weak self] completion in
						self?.isLoading = false
						switch completion {
							case .finished:
								print("Call Invoke finished in Mock Datat Failure Loading Case")
							case .failure(let error):
								self?.showError = true
								self?.errorMessage = error.localizedDescription
						}
					}, receiveValue: { _ in })
					.store(in: &weatherModelCancellable)
					return
			}
		#endif

		self.weatherPublisher(for: location)
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
					self?.temperature = self?.temperatureFormatInDegrees(weatherInfo: weatherModel.current) ?? "--"
					self?.city = weatherModel.location.name
					self?.region = weatherModel.location.region
					self?.windDirection =  "\(weatherModel.current.wind_dir)"
					
				}).store(in: &weatherModelCancellable)
	}
}

