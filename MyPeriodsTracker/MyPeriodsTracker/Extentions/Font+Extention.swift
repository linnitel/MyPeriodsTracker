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

struct MainWidgetInfoTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Ultralight", size: 80))
	}
}

struct EmptyImageTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Ultralight", size: 95))
	}
}

struct EmptyImageWidgetTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Ultralight", size: 75))
	}
}

struct EmptyImageSmallWidgetTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Ultralight", size: 65))
	}
}

struct BaseTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Regular", size: 15))
	}
}

struct BaseWidgetTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Regular", size: 12))
	}
}

struct HeartTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Regular", size: 21))
	}
}

struct BoldTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Bold", size: 15))
	}
}

struct BoldWidgetTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Bold", size: 11))
	}
}

struct PriceTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.custom("SFProText-Bold", size: 21))
	}
}
