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
				HeaderView(todayDate: self.viewModel.todayDate, action: {})
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
				Spacer()
				UpperButton(text: "Period continues", action: {print("upper button")})
				if self.viewModel.model.partOfCycle == .early, self.viewModel.model.partOfCycle == .delay {
					LowerButton(text: "Don't recount", action: { print("lower button")})
				}
				Spacer()
			}
			.padding([.leading, .trailing], 20)
		}
		.modifier(BaseTextModifier())
    }
}

struct MainPeriodsView_Previews: PreviewProvider {
    static var previews: some View {
		MainPeriodsView(viewModel: MainPeriodViewModel())
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
			Rectangle()
				.fill(
					Color(UIColor(named: "line") ?? .white)
						.shadow(.inner(color: Color(UIColor(named: "line") ?? .white), radius: 0.5))
				)
				.frame(height: 2, alignment: .center)
				.cornerRadius(1)
		}
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
			Rectangle()
				.fill(
					Color(UIColor(named: "line") ?? .white)
						.shadow(.inner(color: Color(UIColor(named: "line") ?? .white), radius: 0.5))
				)
				.frame(height: 2, alignment: .center)
				.cornerRadius(1)
		}
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
			Rectangle()
				.fill(
					Color(UIColor(named: "line") ?? .white)
						.shadow(.inner(color: Color(UIColor(named: "line") ?? .white), radius: 0.5))
				)
				.frame(height: 2, alignment: .center)
				.cornerRadius(1)
		}
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
		}
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
