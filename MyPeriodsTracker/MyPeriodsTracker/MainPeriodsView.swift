//
//  MainPeriodsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI

struct MainPeriodsView: View {
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(
				colors: [
					Color(UIColor(named: "backgroundTop") ?? .white),
					Color(UIColor(named: "backgroundBottom") ?? .gray)
				]),
				startPoint: .center,
				endPoint: .bottom
			)
		}
		.ignoresSafeArea()
    }
}

struct MainPeriodsView_Previews: PreviewProvider {
    static var previews: some View {
        MainPeriodsView()
    }
}
