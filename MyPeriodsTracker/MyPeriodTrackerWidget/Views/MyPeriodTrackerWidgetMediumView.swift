//
//  MyPeriodTrackerWidgetMediumView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 07/08/2023.
//

import SwiftUI
import WidgetKit

struct MyPeriodTrackerWidgetMediumView: View {
	let numberOfDays: Int
	let numberOfDaysText: String
	let nextDate: String?
	let nextDateText: String?
	let ovulation: Int
	let fertility: MainPeriodModel.FertilityLevel

    var body: some View {
		ZStack(alignment: .leading) {
			BackgroundView()
			HStack {
				DaysView(daysLeft: self.numberOfDays, text: self.numberOfDaysText, isWidget: true)
					.padding(.top, -20)
					.frame(width: 150)
				DescriptionDataView(
					numberOfDays: numberOfDays,
					nextDate: nextDate,
					nextDateText: nextDateText,
					ovulation: ovulation,
					fertility: fertility
				)
				.padding([.top, .trailing, .bottom], 20)
			}
		}
    }
}

struct DescriptionDataView: View {
	let numberOfDays: Int
	let nextDate: String?
	let nextDateText: String?
	let ovulation: Int
	let fertility: MainPeriodModel.FertilityLevel

	var body: some View {
		VStack{
			if let nextDate = nextDate,
			   let nextDateText = nextDateText {
				CellView(text: nextDateText, value: nextDate)
			} else {
				CellView(text: "Change of cycle", value: String(format: "+%lld days".localized(), numberOfDays))
			}
			CellView(text: "Ovulation", value: String(format: "in %lld days".localized(), ovulation))
			CellView(text: "Fertility", value: fertility.lowercaseLevel, isLast: true)
		}
	}
}

struct CellView: View {
	let text: String
	let value: String
	var isLast: Bool = false

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				VStack(alignment: .leading) {
					Text(LocalizedStringKey(text))
						.modifier(BaseWidgetTextModifier())
					Text(LocalizedStringKey(value))
						.modifier(BoldWidgetTextModifier())
				}
				Spacer()
			}
			if !self.isLast {
				DividerLineView()
			}
		}
	}
}

struct MyPeriodTrackerWidgetMediumView_Previews: PreviewProvider {
    static var previews: some View {
		MyPeriodTrackerWidgetMediumView(
			numberOfDays: 4,
			numberOfDaysText: "days until period",
			nextDate: nil,
			nextDateText: nil,
			ovulation: 14,
			fertility: .veryHigh
		)
		.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


struct MyPeriodTrackerWidgetMediumPlaceholderView: View {
	var body: some View {
		ZStack {
			BackgroundView()
			HStack {
				Image(systemName: "gear.badge.checkmark")
					.foregroundColor(Color("deactivatedText"))
					.modifier(EmptyImageWidgetTextModifier())
					.padding(.leading, 20)
				Text("To see your next period date setup information about your cycle in settings")
					.multilineTextAlignment(.leading)
					.padding(20)
					.foregroundColor(Color("secondButtonText"))
					.modifier(BaseWidgetTextModifier())
			}
		}
	}
}

struct MyPeriodTrackerWidgetMediumPlaceholderView_Previews: PreviewProvider {
	static var previews: some View {
		MyPeriodTrackerWidgetMediumPlaceholderView()
			.previewContext(WidgetPreviewContext(family: .systemMedium))
	}
}
