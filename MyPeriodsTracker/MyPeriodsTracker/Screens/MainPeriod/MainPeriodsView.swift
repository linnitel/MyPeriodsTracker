//
//  MainPeriodsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI
import BackgroundTasks
import os

struct MainPeriodsView: View {
	@StateObject var viewModel: MainPeriodViewModel

	var body: some View {
		NavigationView {
			ZStack(alignment: .top) {
				BackgroundView()
				VStack {
					HeaderView(viewModel: self.viewModel)
					switch self.viewModel.model.status {
						case .offPeriod:
							OffPeriodView(viewModel: self.viewModel)
						case .period:
							PeriodView(viewModel: self.viewModel)
						case .delay:
							DelayView(viewModel: self.viewModel)
						case .notSet:
							NotSetView(viewModel: self.viewModel)
					}
				}
				.padding([.leading, .trailing], 20)
			}
			.modifier(BaseTextModifier())
		}
    }
}

struct MainPeriodsView_Previews: PreviewProvider {
    static var previews: some View {
		MainPeriodsView(viewModel: MainPeriodViewModel(model: MainPeriodModel(pastPeriodStartDate: Date(), periodLength: 5, cycleLength: 30, status: .notSet)))
    }
}

struct HeaderView: View {
	@StateObject var viewModel: MainPeriodViewModel

	var body: some View {
		ZStack {
			Text(self.viewModel.todayDate.dateMonthAndWeekString)
			HStack {
				Spacer()
				NavigationLink(destination: SettingsView(viewModel: self.viewModel)) {
					Image("settings")
						.frame(width: 40, height: 40)
				}
			}
		}
	}
}

struct OffPeriodView: View {
	@ObservedObject var viewModel: MainPeriodViewModel

	var body: some View {
		VStack {
			DaysView(daysLeft: self.viewModel.daysLeft(), text: "days until period")
				.padding(.bottom, 40)
			Group {
				DateItemView(value: self.viewModel.nextPeriodDate(), text: "Next period")
				OvulationView(value: self.viewModel.ovulation())
				FertilityView(value: self.viewModel.fertility())
			}
			.padding([.leading, .trailing], 4)
			.padding([.top], 16)
			Spacer()
			if viewModel.showOffPeriodButton() {
				UpperButton(text: "Period start early", action: {
					UserDefaults.standard.set(Date().midnight.timeIntervalSince1970, forKey: "PeriodStartDate")
					self.viewModel.model.pastPeriodStartDate = Date().midnight
					self.viewModel.setStatus(to: .period)
					self.viewModel.logger.log("The button \"Period start early\" was pushed")
				})
				Spacer()
			}
		}
	}
}

struct PeriodView: View {
	@ObservedObject var viewModel: MainPeriodViewModel

	var body: some View {
		VStack {
			DaysView(daysLeft: self.viewModel.dayOfPeriod(), text: "day of period")
				.padding(.bottom, 40)
			Group {
				DateItemView(value: self.viewModel.endOfPeriodDate(), text: "End of period")
				OvulationView(value: self.viewModel.ovulation())
				FertilityView(value: self.viewModel.fertility())
			}
			.padding([.leading, .trailing], 4)
			.padding([.top], 16)
			Spacer()
			UpperButton(text: "Period didn't start", action: {
				self.viewModel.setStatus(to: .delay)
				self.viewModel.logger.log("The button \"Period didn't start\" was pushed")
			})
			Spacer()
		}
	}
}

struct DelayView: View {
	@ObservedObject var viewModel: MainPeriodViewModel

	var body: some View {
		VStack {
			DaysView(daysLeft: self.viewModel.delay(), text: "day of delay")
				.padding(.bottom, 40)
			Group {
				DateDelayView(value: self.viewModel.delay(), isDelay: true)
				OvulationView(value: self.viewModel.ovulation())
				FertilityView(value: self.viewModel.fertility())
			}
			.padding([.leading, .trailing], 4)
			.padding([.top], 16)
			Spacer()
			UpperButton(text: "Period started", action:{
				UserDefaults.standard.set(Date().midnight.timeIntervalSince1970, forKey: "PeriodStartDate")
				self.viewModel.model.pastPeriodStartDate = Date().midnight
				self.viewModel.setStatus(to: .period)
				self.viewModel.logger.log("The button \"Period started\" was pushed")
			})
			Spacer()
		}
	}
}

struct NotSetView: View {
	@StateObject var viewModel: MainPeriodViewModel

	var body: some View {
		VStack {
			Spacer()
			Image(systemName: "gear.badge.checkmark")
				.foregroundColor(Color("deactivatedText"))
				.modifier(EmptyImageTextModifier())
			Text("To see your next period date setup information about your cycle in settings")
				.multilineTextAlignment(.center)
				.padding([.leading, .trailing], 40)
				.padding([.top], 16)
				.foregroundColor(Color("secondButtonText"))
			Spacer()
		}
	}
}

struct DaysView: View {
	let daysLeft: Int
	let text: String

	var body: some View {
		VStack {
			let localizedText = String(format: NSLocalizedString("%lld \(text)", comment: ""), daysLeft)
			let splittedStringsArray = localizedText.split(separator: " ", maxSplits: 1)
			Text(splittedStringsArray[0])
				.foregroundColor(Color.accentColor)
				.modifier(MainInfoTextModifier())
				.padding([.bottom], -30)
			Text(splittedStringsArray[1])
		}
	}


}

struct DateItemView: View {
	let value: String
	let text: String

	var body: some View {
		VStack {
			HStack {
				Text(LocalizedStringKey(text))
				Spacer()
				Text(LocalizedStringKey(value))
			}
			.padding([.top, .bottom], 16)
			DividerLineView()
		}
		.frame(height: 38)
	}

}

struct DateDelayView: View {
	let value: Int
	let isDelay: Bool

	var body: some View {
		VStack {
			HStack {
				Text("Change of cycle")
				Spacer()
				if isDelay {
					Text("+\(value) days")
						.foregroundColor(.accentColor)
				} else {
					Text("\(value) days")
						.foregroundColor(.accentColor)
				}
			}
			.padding([.top, .bottom], 16)
			DividerLineView()
		}
		.frame(height: 38)
	}

}

struct OvulationView: View {
	let value: Int

	var body: some View {
		VStack {
			HStack {
				Text("Ovulation")
				Spacer()
				let localizedText = String(format: NSLocalizedString("in %lld days", comment: ""), value)
				Text(LocalizedStringKey(localizedText))
			}
			.padding([.top, .bottom], 16)
			DividerLineView()
		}
		.frame(height: 38)
	}
}

struct FertilityView: View {
	let value: MainPeriodModel.FertilityLevel

	var body: some View {
		VStack {
			HStack {
				Text("Fertility")
				Spacer()
				Text(LocalizedStringKey(value.level))
					.foregroundColor(value.color)

			}
			.padding([.top, .bottom], 16)
		}
		.frame(height: 38)
	}
}

struct UpperButton: View {
	let text: String
	let action: () -> Void

	var body: some View {
		Button(action: self.action) {
			ButtonBackgroundView {
				Text(LocalizedStringKey(self.text))
			}
			.frame(height: 56)
		}
	}
}

struct LowerButton: View {
	let text: String
	let action: () -> Void

	var body: some View {
		Button(action: self.action) {
			ZStack {
				Text(LocalizedStringKey(self.text))
					.foregroundColor(Color(UIColor(named: "secondButtonText") ?? .black))
				RoundedRectangle(cornerRadius: 16)
					.fill(Color.clear)
					.frame(height: 56)
			}
		}
	}
}
