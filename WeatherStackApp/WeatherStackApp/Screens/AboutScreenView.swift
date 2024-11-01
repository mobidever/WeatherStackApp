//
//  AboutScreenView.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI

struct AboutScreenView: View {
	
	@State private var shadowColor: Color = .green
	@State private var shadowRadius: CGFloat = 8
	@State private var shadowX: CGFloat = 20
	@State private var shadowY: CGFloat = 0
	
    var body: some View {
		
		ZStack {

			Color.appTheme.gradientBackground.ignoresSafeArea()
		
			VStack {
				Text("WeatherStackApp showcases current Temperature and Wind Direction for Mumbai, Maharashtra by Default, whenever HomeTab is loaded.")
					.font(.title3)
					.fontWeight(.bold)
					.padding()
					.accessibilityIdentifier("AppDetailsText")
				
				Text("MVVM Architecture,  SOLID principles and Mock Services for XCTestCase execution are the concepts used.")
					.font(.title3)
					.fontWeight(.semibold)
					.padding()
					.accessibilityIdentifier("AppArchitectureText")
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
			.onAppear {
				withAnimation(.linear(duration: 2.5)) {
					shadowColor = .blue
					shadowRadius = 2
					shadowX = 5
					shadowY = 5
				}
			}.overlay {
				RoundedRectangle(cornerRadius: 50)
					.foregroundColor(Color(UIColor.systemBrown))
					.opacity(0.2)
					.shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
			}.padding(20)
		
		}
    }
}

#Preview {
    AboutScreenView()
}
