//
//  MainPeriodsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 09/06/2023.
//

import SwiftUI

struct MainPeriodsView: View {
	@StateObject var viewModel: MainPeriodViewModel

	var body: some View {
		NavigationView {
			ZStack(alignment: .top) {
				BackgroundView()
				VStack {
					HeaderView(todayDate: self.viewModel.todayDate, startDate: $viewModel.model.periodStartDate, cycle: $viewModel.model.cycleLength, period: self.$viewModel.model.periodLength)
					DaysView(daysLeft: self.viewModel.daysLeft())
						.padding(.bottom, 40)
					Group {
						switch self.viewModel.model.partOfCycle {
							case .period, .delay, .early:
								DateDelayView(value: self.viewModel.delay(), isDelay: self.viewModel.isDelay())
							case .offPeriod, .notSet:
								DateItemView(value: self.viewModel.nextPeriodDate())
						}
						OvulationView(value: self.viewModel.ovulation())
						FertilityView(value: self.viewModel.fertility())
					}
					.padding([.leading, .trailing], 4)
					.padding([.top], 16)
					Spacer()
					UpperButton(text: "Period continues", action:{ self.viewModel.upperButtonAction()})
					if self.viewModel.model.partOfCycle == .early || self.viewModel.model.partOfCycle == .delay {
						LowerButton(text: "Don't recount", action: { print("lower button")})
					}
					Spacer()
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

	var body: some View {
		ZStack {
			Text(DateCalculatiorService.shared.getDateMonthAndWeek(todayDate))
			HStack {
				Spacer()
				NavigationLink(destination: SettingsView(startDate: $startDate, cycle: $cycle, period: $period)) {
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
				.padding([.bottom], -30)
			Text("days until period")

		}
	}


}

struct DateItemView: View {
	let value: String

	var body: some View {
		VStack {
			HStack {
				Text("Next period")
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
					Text("-\(value) days")
						.foregroundColor(.accentColor)
				} else {
					Text("+\(value) days")
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

struct UpperButton: View {
	let text: String
	let action: () -> Void

	var body: some View {
		Button(action: self.action) {
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
