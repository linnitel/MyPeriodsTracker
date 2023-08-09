//
//  MyPeriodTrackerWidgetSmallView.swift
//  MyPeriodTrackerWidgetExtension
//
//  Created by Julia Martcenko on 07/08/2023.
//

import SwiftUI
import WidgetKit

struct MyPeriodTrackerWidgetSmallView: View {
	let numberOfDays: Int
	let text: String

    var body: some View {
		ZStack {
			BackgroundView()
			DaysView(daysLeft: self.numberOfDays, text: self.text, isWidget: true)
				.padding(.top, -20)
		}
    }
}

struct MyPeriodTrackerWidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {
        MyPeriodTrackerWidgetSmallView(numberOfDays: 22, text: "days until period")
			.previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct MyPeriodTrackerWidgetSmallPlaceholderView: View {
	var body: some View {
		ZStack {
			BackgroundView()
			VStack {
				Image(systemName: "gear.badge.checkmark")
					.foregroundColor(Color("deactivatedText"))
					.modifier(EmptyImageSmallWidgetTextModifier())
					.padding(.bottom, 1)
				Text("setup information in settings")
					.multilineTextAlignment(.center)
					.foregroundColor(Color("secondButtonText"))
					.modifier(BaseWidgetTextModifier())
			}
		}
	}
}

struct MyPeriodTrackerWidgetSmallPlaceholderView_Previews: PreviewProvider {
	static var previews: some View {
		MyPeriodTrackerWidgetSmallPlaceholderView()
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}
