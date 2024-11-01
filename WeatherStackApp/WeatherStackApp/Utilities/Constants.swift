//
//  Constants.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import Foundation

// api key used to load services
let api_key : String = "18958cb350fe932cdd4532589ea43ebb"

//URLs to load services from WeatherStack.
struct Urls {
	
	static func weatherInfoURL(for location: String) -> URL {
		return URL(string: "https://api.weatherstack.com/current?access_key=\(api_key)&query=\(location)")!
	}
}
