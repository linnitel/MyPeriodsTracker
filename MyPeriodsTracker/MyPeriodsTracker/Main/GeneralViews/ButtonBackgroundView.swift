//
//  ButtonBackgroundView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 14/07/2023.
//

import SwiftUI

struct ButtonBackgroundView<Content: View>: View {
	@ViewBuilder var content: Content

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16)
				.foregroundColor(.white)
				.padding([.top, .leading], -2)
				.shadow(color: Color(UIColor(named: "buttonShadow") ?? .gray),radius: 16, x: 8, y: 16)
				.shadow(color: .white,radius: 16, x: -8, y: -16)
			RoundedRectangle(cornerRadius: 16)
				.fill(
					LinearGradient(gradient: Gradient(
						colors: [
							Color(UIColor(named: "buttonBottom") ?? .white),
							Color(UIColor(named: "buttonTop") ?? .gray)
						]),
								   startPoint: .top,
								   endPoint: .bottom
					)
				)
			content
		}
	}
}

struct ButtonBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
		ButtonBackgroundView() {
			Text("Testing view")
		}
		.frame(height: 56)
		.padding(16)
    }
}
