//
//  SettingsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 20/06/2023.
//

import SwiftUI

struct SettingsView: View {
	let cycleArray = [21, 22, 23, 24, 25,
					  26, 27, 28, 29, 30,
					  31, 32, 33, 34, 35]
	let periodArray = [2, 3, 4, 5, 6, 7]

	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@Binding var periodStartDate: Date
	@Binding var cycle: Int
	@Binding var period: Int
	@Binding var partOfCycle: MainPeriodModel.PartOfCycle

	@State private var cycleIsShown = false
	@State private var periodIsShown = false
	@State private var startDateIsShown = false

    var body: some View {
		NavigationView {
			ZStack(alignment: .top) {
				BackgroundView()
				VStack {
					ZStack(alignment: .center) {
						HStack(alignment: .center) {
							Button(action: {
								self.partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(
									periodStartDate: self.periodStartDate,
									periods: self.period,
									cycle: self.cycle,
									partOfCycle: self.partOfCycle,
									now: Date().midnight
								)
								// TODO: One source of truth for today date?
								self.presentationMode.wrappedValue.dismiss()
							}) {
								Image(systemName: "arrow.left")
									.padding()
									.foregroundColor(.black)
							}
							Spacer()
						}
						Text("Settings")
					}
					.padding(.bottom, 16)
					Group {
						SettingsItemView(text: "Cycle length", selectionArray: cycleArray, isShown: $cycleIsShown, value: $cycle, key: "CycleLength") {
							self.cycleIsShown.toggle()
							self.periodIsShown = false
							self.startDateIsShown = false
						}
						SettingsItemView(text: "Period length", selectionArray: periodArray, isShown: $periodIsShown, value: $period, key: "PeriodLength") {
							self.periodIsShown.toggle()
							self.cycleIsShown = false
							self.startDateIsShown = false
						}
						LastDateItemView(date: self.$periodStartDate, isShown: $startDateIsShown) {
							self.startDateIsShown.toggle()
							self.periodIsShown = false
							self.cycleIsShown = false
						}
						NotificationsItem(periodStartDate: self.periodStartDate, cycle: self.cycle, period: self.period)
					}
					.padding([.leading, .trailing], 24)
					Spacer()
					// TODO: add storekit items for donation
//					LowerButton(text: "Rate the app in AppStore", action: {
//						// TODO: add link to the appstore to rate the app
//					})
				}
			}
			.modifier(BaseTextModifier())
		}
		.navigationBarHidden(true)
		.onAppear() {
			UserDefaults.standard.set(true, forKey: "NotFirstLaunch")
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(periodStartDate: .constant(Date().midnight), cycle: .constant(30), period: .constant(5), partOfCycle: .constant(.delay))
    }
}

struct SettingsItemView: View {
	let text: String
	let selectionArray: [Int]
	@Binding var isShown: Bool
	@Binding var value: Int
	let key: String
	let action: () -> Void

	var body: some View {
		VStack {
			Button(action: action) {
				HStack {
					Text(LocalizedStringKey(self.text))
						.foregroundColor(.black)
					Spacer()
					Text("\(value) days")
						.foregroundColor(.accentColor)
				}
			}
			.padding([.top, .bottom], 16)
			if isShown {
				Picker("", selection: $value) {
						ForEach(selectionArray, id: \.self) { value in
							Text("\(value)")
						}
				}
				.pickerStyle(.wheel)
				.onReceive([self.value].publisher.first()) { (value) in
					UserDefaults.standard.set(self.value, forKey: self.key)
					print(value)
				}
			}
			DividerLineView()
		}
	}
}

struct LastDateItemView: View {
	@Binding var date: Date
	@Binding var isShown: Bool

	let action: () -> Void

	var body: some View {
		VStack {
			Button(action: action) {
				HStack {
					Text("Previous period start")
						.foregroundColor(.black)
					Spacer()
					Text(date, style: .date)
				}
				.padding([.top, .bottom], 16)
			}
			if isShown {
				DatePicker("", selection: $date, in: Date(timeIntervalSince1970: Date().midnight.timeIntervalSince1970 - 7889229)...Date().midnight, displayedComponents: .date)
					.datePickerStyle(WheelDatePickerStyle())
					.onReceive([self.date].publisher.first()) { (value) in
						UserDefaults.standard.set(self.date.timeIntervalSince1970, forKey: "PeriodStartDate")
					}
			}
			DividerLineView()
		}

	}
}

struct NotificationsItem: View {
	let periodStartDate: Date
	let cycle: Int
	let period: Int

	var body: some View {
		HStack {
			Text("Notifications")
			Spacer()
			NavigationLink(destination: NotificationSettings(viewModel: NotificationSettingsViewModel(
				periodStartDate: self.periodStartDate,
				cycle: self.cycle,
				period: self.period
			))) {
				Image(systemName: "chevron.right")
					.foregroundColor(Color(UIColor(named: "secondButtonText") ?? .gray))
			}
		}
		.frame(height: 46)
	}
}

