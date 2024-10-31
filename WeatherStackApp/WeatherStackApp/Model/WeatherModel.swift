//
//  WeatherModel.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

struct WeatherModel : Codable{
	
	var current : CurrentWeatherInfo
	var location : Location
}

struct CurrentWeatherInfo : Codable {
	
	var temperature : Int
	var wind_dir : String
	var wind_degree : Int
}

struct Location: Codable {
	var name: String
	var region : String
}

