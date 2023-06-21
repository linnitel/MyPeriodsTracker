//
//  BackgroundView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 21/06/2023.
//

import SwiftUI

struct BackgroundView: View {
	var body: some View {
		LinearGradient(gradient: Gradient(
			colors: [
				Color(UIColor(named: "backgroundTop") ?? .white),
				Color(UIColor(named: "backgroundBottom") ?? .gray)
			]),
					   startPoint: .center,
					   endPoint: .bottom
		)
		.ignoresSafeArea()
	}
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
