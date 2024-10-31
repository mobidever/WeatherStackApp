//
//  AppExtensions.swift
//  WeatherStackApp
//
//  Created by PS on 30/10/24.
//

import Foundation
import SwiftUI

extension UIApplication {
	
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
