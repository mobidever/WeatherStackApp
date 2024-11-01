//
//  Constants.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import Foundation

// api key used to load services
let api_key : String = "f8e03f315d56dd4ced3c5e74d11ff124"

//URLs to load services from WeatherStack.
struct Urls {
	
	static func weatherInfoURL(for location: String) -> URL {
		return URL(string: "https://api.weatherstack.com/current?access_key=\(api_key)&query=\(location)")!
	}
}
