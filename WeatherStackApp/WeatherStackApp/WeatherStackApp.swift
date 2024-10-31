//
//  WeatherStackApp.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI

@main
struct WeatherStackApp: App {
    var body: some Scene {
        WindowGroup {
			TabBarScreenView(selectedTabView: .home)
        }
    }
}
