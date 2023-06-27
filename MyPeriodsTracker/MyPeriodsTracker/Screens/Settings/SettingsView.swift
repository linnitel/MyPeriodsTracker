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

	@Binding var startDate: Date
	@Binding var cycle: Int
	@Binding var period: Int
	@Binding var partOfCycle: Int

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
								if cycle != 0, period != 0, startDate.timeIntervalSince1970 != 0 {
									if self.partOfCycle != MainPeriodModel.PartOfCycle.delay.rawValue, self.partOfCycle != MainPeriodModel.PartOfCycle.early.rawValue {
										partOfCycle = MainPeriodModel.PartOfCycle.offPeriod.rawValue
									}
								}
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
						SettingsItemView(text: "Cycle length", selectionArray: cycleArray, isShown: $cycleIsShown, value: $cycle) {
							self.cycleIsShown.toggle()
							self.periodIsShown = false
							self.startDateIsShown = false
							UserDefaults.standard.set(self.cycle, forKey: "CycleLength")
						}
						SettingsItemView(text: "Period length", selectionArray: periodArray, isShown: $periodIsShown, value: $period) {
							self.periodIsShown.toggle()
							self.cycleIsShown = false
							self.startDateIsShown = false
							UserDefaults.standard.set(self.period, forKey: "PeriodLength")
						}
						LastDateItemView(date: self.$startDate, isShown: $startDateIsShown) {
							self.startDateIsShown.toggle()
							self.periodIsShown = false
							self.cycleIsShown = false
							UserDefaults.standard.set(self.startDate.timeIntervalSince1970, forKey: "PeriodStartDate")
						}
						NotificationsItem()
					}
					.padding([.leading, .trailing], 24)
					Spacer()
					LowerButton(text: "Rate the app in AppStore", action: {})
				}
			}
			.modifier(BaseTextModifier())
		}
		.navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(startDate: .constant(Date()), cycle: .constant(30), period: .constant(5), partOfCycle: .constant(1))
    }
}

struct SettingsItemView: View {
	let text: String
	let selectionArray: [Int]
	@Binding var isShown: Bool
	@Binding var value: Int
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
				DatePicker("", selection: $date, in: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 7889229)...Date(), displayedComponents: .date)
					.datePickerStyle(WheelDatePickerStyle())
			}
			DividerLineView()
		}

	}
}

struct NotificationsItem: View {
	var body: some View {
		HStack {
			Text("Notifications")
			Spacer()
			NavigationLink(destination: NotificationSettings(viewModel: NotificationSettingsViewModel())) {
				Image(systemName: "chevron.right")
					.foregroundColor(Color(UIColor(named: "secondButtonText") ?? .gray))
			}
		}
		.frame(height: 46)
	}
}

