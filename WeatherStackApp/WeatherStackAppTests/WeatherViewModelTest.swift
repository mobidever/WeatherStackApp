//
//  WeatherViewModelTest.swift
//  WeatherStackAppTests
//
//  Created by PS on 31/10/24.
//

import XCTest
import Combine
@testable import WeatherStackApp


class MockHttpClient: NetworkClient {
	
	var weatherPublisher : AnyPublisher<Data,Error>?
	func fetchData(from url: URL) -> AnyPublisher<Data, any Error> {
		
		if let result = weatherPublisher{
			return result
		}else {
			fatalError("Error While Initializing FetchData of MockHTTPClient")
		}
	}
}

final class WeatherViewModelTest: XCTestCase {
	

	private var weatherModelCancellable = Set<AnyCancellable>()
	private var weatherInfoJSON_SuccessResponseURL : URL?
	private var weatherInfoJSON_DecodeFailureURL : URL?
	var weatherVM : WeatherViewModel!
	var mockHTTPClient : MockHttpClient!
	
    override func setUpWithError() throws {
		
		//JSON Data - Success path
		let testBundle = Bundle(for: type(of: self))
		
		self.weatherInfoJSON_SuccessResponseURL = testBundle.url(forResource: "weatherInfo",
										withExtension: "json")
		
		self.weatherInfoJSON_DecodeFailureURL = testBundle.url(forResource: "weatherInfo_Failure",
												withExtension: "json")
		
        // Put setup code here. This method is called before the invocation of each test method in the class.
		mockHTTPClient = MockHttpClient()
		weatherVM = WeatherViewModel(httpClient: mockHTTPClient)
		
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	/*
	 TestCase : Given a CurrentWeatherInfo Object, temperature should be string formatted with °C
	 */

	func test_TemperatureFormat() {
		
		let currentWeatherInfo = CurrentWeatherInfo(temperature: 25, wind_dir: "NE", wind_degree: 50)
		let formattedTemperature = self.weatherVM.temperatureFormatInDegrees(weatherInfo: currentWeatherInfo)
		XCTAssertEqual(formattedTemperature, "25°C")
	}

	/*
	 TestCase : Given Invalid JSON,WeatherViewModel's  weatherPublisher should execute failure case of Sink.
	 */
	func test_WeatherPublisher_Sink_Failure() throws {
		
		let invalidJSONDecodeExpectation = XCTestExpectation(description: "Expect WeatherPublisher to emit the JSON Values")

		do {
			//given
			let weatherJSON_DecodeFailureData = try Data(contentsOf: self.weatherInfoJSON_DecodeFailureURL!)
			mockHTTPClient.weatherPublisher = CurrentValueSubject(weatherJSON_DecodeFailureData).eraseToAnyPublisher()
			
			//when
			weatherVM.weatherPublisher(for: "Hyderabad")
				.decode(type: WeatherModel.self, decoder: JSONDecoder())
				.sink { completion in
					switch completion {
						case .finished:
							print("Call invoke Finished")
						case .failure(let error):
							XCTAssertNotNil(error)
							XCTAssertTrue(error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format.")
							invalidJSONDecodeExpectation.fulfill()
							print("Call invoke Failed with error: \(error.localizedDescription)")
					}
					
				} receiveValue: { weatherModel in
				}.store(in: &weatherModelCancellable)
			wait(for: [invalidJSONDecodeExpectation], timeout: 3)
			
		} catch {
			print(error.localizedDescription)
			throw error
		}
	}
	
	/*
	 TestCase : Given Valid JSON, WeatherViewModel's weatherPublisher should execute  receieveValue Closure with WeatherModel data decoded successfully.
	 */
	func test_WeatherPublisher_ReceiveValue_Success() throws {
		
		let receiveJSON_ReceiveValueExpectation = XCTestExpectation(description: "Expect WeatherPublisher to emit the Valid JSON Response and receiveValue ")
		
		do {
			//given
			let weatherJSON_SuccessData = try Data(contentsOf: self.weatherInfoJSON_SuccessResponseURL!)
			mockHTTPClient.weatherPublisher = CurrentValueSubject(weatherJSON_SuccessData).eraseToAnyPublisher()
			
			//when - Invoke weatherPublisher
			weatherVM.weatherPublisher(for: "Hyderabad")
				.decode(type: WeatherModel.self, decoder: JSONDecoder())
				.sink { completion in
					switch completion {
						case .finished:
							print("Call invoke Finished")
						case .failure(let error):
							print("Call invoke Failed with error: \(error.localizedDescription)")
					}
				
				} receiveValue: { weatherModel in
					XCTAssertNoThrow(weatherModel)
					XCTAssertEqual(weatherModel.location.name,"Hyderabad")
					XCTAssertEqual(weatherModel.current.wind_dir, "ESE")
					XCTAssertEqual(weatherModel.current.temperature, 28)
					XCTAssertEqual(weatherModel.current.wind_degree, 122)
					receiveJSON_ReceiveValueExpectation.fulfill()
				}
				.store(in: &weatherModelCancellable)
			wait(for: [receiveJSON_ReceiveValueExpectation], timeout: 5)
			
		} catch {
			print(error.localizedDescription)
			throw error
		}
	}
}
