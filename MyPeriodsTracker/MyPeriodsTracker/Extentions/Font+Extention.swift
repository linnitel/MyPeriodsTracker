//
//  Font+Extention.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI

struct MainInfoTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Ultralight", size: 160))
	}
}

struct BaseTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Regular", size: 15))
	}
}
