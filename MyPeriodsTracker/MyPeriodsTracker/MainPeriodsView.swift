//
//  MainPeriodsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI

struct MainPeriodsView: View {
	@State var todayDate: Date = Date()
	@State var daysLeft: Int = 22

	var body: some View {
		ZStack(alignment: .top) {
			LinearGradient(gradient: Gradient(
				colors: [
					Color(UIColor(named: "backgroundTop") ?? .white),
					Color(UIColor(named: "backgroundBottom") ?? .gray)
				]),
				startPoint: .center,
				endPoint: .bottom
			)
			.ignoresSafeArea()
			VStack {
				HeaderView(todayDate: todayDate, action: {})
				DaysView(daysLeft: daysLeft)
			}
			.padding()
		}
    }
}

struct MainPeriodsView_Previews: PreviewProvider {
    static var previews: some View {
        MainPeriodsView()
    }
}

struct HeaderView: View {
	let todayDate: Date
	let action: () -> Void

	var body: some View {
		ZStack {
			Text(DateCalculatiorService.shared.getDateMonthAndWeek(todayDate))
			HStack {
				Spacer()
				Button(action: action) {
					Image("settings")
						.frame(width: 40, height: 40)
				}
			}
		}
	}
}

struct DaysView: View {
	let daysLeft: Int

	var body: some View {
		VStack {
			Text(String(daysLeft))
				.foregroundColor(Color.accentColor)
				.modifier(MainInfoTextModifier())
			Text("MainPeriodsView.DaysView.daysUntilPeriod".localized())
		}
	}
}
