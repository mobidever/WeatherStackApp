//
//  TabBarScreen.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import SwiftUI

enum TabScreenView: Hashable,Identifiable,CaseIterable {

	case home
	case about
	
	var id: TabScreenView{self}
}

extension TabScreenView {
	
	@ViewBuilder
	var label: some View {
		
		switch self {
			case .home:
				Label("Home",systemImage: "house")
			case .about:
				Label("Info",systemImage: "info")
		}
	}
	
	@MainActor
	@ViewBuilder
	var destination: some View {
		
		switch self {
			case .home:
				
				NavigationStack{
					HomeScreenView()
				}
				
			case .about:
				
				NavigationStack{
					AboutScreenView()
				}
		}
	}
}

struct TabBarScreenView: View {
	
	@State var selectedTabView : TabScreenView
    var body: some View {
        
		TabView(selection: $selectedTabView) {
			ForEach(TabScreenView.allCases) { screenView in
				
				screenView.destination.tag(screenView as TabScreenView?)
					.tabItem {
						screenView.label
					}
				
				}
		}
    }
}

#Preview {
	TabBarScreenView(selectedTabView: .home)
}
