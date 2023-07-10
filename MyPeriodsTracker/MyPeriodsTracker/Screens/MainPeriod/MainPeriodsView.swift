//
//  MainPeriodsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI
import BackgroundTasks

struct MainPeriodsView: View {
	@StateObject var viewModel: MainPeriodViewModel

	var body: some View {
		NavigationView {
			ZStack(alignment: .top) {
				BackgroundView()
				VStack {
					HeaderView(
						todayDate: self.viewModel.todayDate,
						startDate: $viewModel.model.periodStartDate,
						cycle: $viewModel.model.cycleLength,
						period: self.$viewModel.model.periodLength,
						partOfCycle: self.$viewModel.partOfCycle
					)
					switch self.viewModel.partOfCycle {
						case .offPeriod:
							OffPeriodView(viewModel: self.viewModel, partOfCycle: self.$viewModel.partOfCycle)
						case .period:
							PeriodView(viewModel: self.viewModel, partOfCycle: self.$viewModel.partOfCycle)
						case .delay:
							DelayView(viewModel: self.viewModel, partOfCycle: self.$viewModel.partOfCycle)
						case .notSet:
							NotSetView(
								viewModel: self.viewModel,
								partOfCycle: self.$viewModel.partOfCycle,
								startDate: self.$viewModel.model.periodStartDate,
								cycle: self.$viewModel.model.cycleLength,
								period: self.$viewModel.model.periodLength
							)
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
		MainPeriodsView(viewModel: MainPeriodViewModel())
    }
}

struct HeaderView: View {
	let todayDate: Date
	@Binding var startDate: Date
	@Binding var cycle: Int
	@Binding var period: Int
	@Binding var partOfCycle: MainPeriodModel.PartOfCycle

	var body: some View {
		ZStack {
			Text(DateToStringService.shared.dateMonthAndWeekString(from: todayDate))
			HStack {
				Spacer()
				NavigationLink(destination: SettingsView(periodStartDate: $startDate, cycle: $cycle, period: $period, partOfCycle: $partOfCycle)) {
					Image("settings")
						.frame(width: 40, height: 40)
				}
			}
		}
	}
}

struct OffPeriodView: View {
	@ObservedObject var viewModel: MainPeriodViewModel
	@Binding var partOfCycle: MainPeriodModel.PartOfCycle

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
					self.viewModel.model.periodStartDate = Date().midnight
					self.partOfCycle = .period
				})
				Spacer()
			}
		}
	}
}

struct PeriodView: View {
	@ObservedObject var viewModel: MainPeriodViewModel
	@Binding var partOfCycle: MainPeriodModel.PartOfCycle

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
				self.partOfCycle = .delay
			})
			Spacer()
		}
	}
}

struct DelayView: View {
	@ObservedObject var viewModel: MainPeriodViewModel
	@Binding var partOfCycle: MainPeriodModel.PartOfCycle

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
				self.viewModel.model.periodStartDate = Date().midnight
				self.partOfCycle = .period
			})
			Spacer()
		}
	}
}

struct NotSetView: View {
	@ObservedObject var viewModel: MainPeriodViewModel
	@Binding var partOfCycle: MainPeriodModel.PartOfCycle
	@Binding var startDate: Date
	@Binding var cycle: Int
	@Binding var period: Int

	var body: some View {
		VStack {
			DaysView(daysLeft: 0, text: "day of period")
				.padding(.bottom, 40)
			Text("To see your next period date setup information about your cycle in settings")
				.multilineTextAlignment(.center)
				.padding([.leading, .trailing], 40)
				.padding([.top], 16)
			Spacer()
			NavigationLink(destination: SettingsView(
				periodStartDate: $startDate,
				cycle: $cycle,
				period: $period,
				partOfCycle: $partOfCycle
			)) {
				ButtonBackgroundView(text: "Open settings")
			}
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
				Text("in \(value) days")
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

struct ButtonBackgroundView: View {
	let text: String

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16)
				.foregroundColor(.white)
				.frame(height: 56)
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
				.frame(height: 56)
			Text(LocalizedStringKey(self.text))
		}
	}
}

struct UpperButton: View {
	let text: String
	let action: () -> Void

	var body: some View {
		Button(action: self.action) {
			ButtonBackgroundView(text: text)
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
