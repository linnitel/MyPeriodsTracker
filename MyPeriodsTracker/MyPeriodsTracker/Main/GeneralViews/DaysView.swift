//
//  DaysView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 07/08/2023.
//

import SwiftUI

struct DaysView: View {
	let daysLeft: Int
	let text: String
	let isWidget: Bool

	var body: some View {
		VStack {
			let localizedText = String(format: NSLocalizedString("%lld \(text)", comment: ""), daysLeft)
			let splittedStringsArray = localizedText.split(separator: " ", maxSplits: 1)
			if isWidget {
				Text(splittedStringsArray[0])
					.foregroundColor(Color(UIColor(named: "AccentColor") ?? .red))
					.modifier(MainWidgetInfoTextModifier())
					.padding([.bottom], -15)
				Text(splittedStringsArray[1])
					.modifier(BaseWidgetTextModifier())
			} else {
				Text(splittedStringsArray[0])
					.foregroundColor(Color(UIColor(named: "AccentColor") ?? .red))
					.modifier(MainInfoTextModifier())
					.padding([.bottom], -30)
				Text(splittedStringsArray[1])
			}

		}
	}
}

struct DaysView_Previews: PreviewProvider {
    static var previews: some View {
        DaysView(daysLeft: 22, text: "days until period", isWidget: true)
    }
}
