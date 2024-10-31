//
//  WeatherInfoView.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI

struct WeatherInfoView: View {
	
	var temperature: String
	var windDirection: String
	var region:String
	var locationName : String
	
    var body: some View {
		VStack(alignment: .center) {
			Text(locationName)
				.font(.largeTitle)
				.bold()
			
			Text(region)
				.font(.title)
			
			Text(temperature)
				.font(.system(size: 70))
				.bold()
			
			Text("Wind Direction: \(windDirection)")
				.font(.title2)
				.padding(.bottom,5)
		}
	
    }
	
	
	
}



#Preview {
//	WeatherInfoView(temperature: "26", condition: "Haze", region: "India", locationName: "Mumbai")
}
