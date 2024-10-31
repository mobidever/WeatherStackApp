//
//  Constants.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import Foundation

let api_key : String = "18958cb350fe932cdd4532589ea43ebb"

struct Urls {
	
	static func weatherInfoURL(for location: String) -> URL {
		return URL(string: "https://api.weatherstack.com/current?access_key=\(api_key)&query=\(location)")!
	}
	
	//Available on standard plans
	static func weatherForecastURL(for location: String) -> URL{
		return URL(string: "https://api.weatherstack.com/current?access_key=\(api_key)&query=\(location)&forecast_days=1&hourly=1")!
	}
	
	static func search(for location:String) -> URL {
		return URL(string: "https://api.weatherstack.com/autocomplete?access_key=\(api_key)&query=\(location)")!
	}
	
}
