//
//  Colors.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI

extension Color{
	
	static let appTheme = WeatherColorTheme()
}

struct WeatherColorTheme {
	let accent = Color("AccentColour")
	let backgroundColor = Color("BackgroundColor")
	let gradientBackground = LinearGradient(gradient: Gradient(colors: [.blue,.white]), startPoint: .top, endPoint: .bottom)
	let secondaryTextColor = Color("SecondaryTextColour")
}
