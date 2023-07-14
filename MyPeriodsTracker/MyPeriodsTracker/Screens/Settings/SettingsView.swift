//
//  SettingsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 20/06/2023.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
	let cycleArray = [21, 22, 23, 24, 25,
					  26, 27, 28, 29, 30,
					  31, 32, 33, 34, 35]
	let periodArray = [2, 3, 4, 5, 6, 7]

	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@StateObject var viewModel: MainPeriodViewModel

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
								self.viewModel.partOfCycle = DateCalculatorService.shared.partOfCycleUpdate(
									periodStartDate: self.viewModel.model.periodStartDate,
									periods: self.viewModel.model.periodLength,
									cycle: self.viewModel.model.cycleLength,
									partOfCycle: self.viewModel.partOfCycle,
									now: self.viewModel.todayDate
								)
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
						SettingsItemView(text: "Cycle length", selectionArray: cycleArray, isShown: $cycleIsShown, value: self.$viewModel.model.cycleLength, key: "CycleLength") {
							self.cycleIsShown.toggle()
							self.periodIsShown = false
							self.startDateIsShown = false
						}
						SettingsItemView(text: "Period length", selectionArray: periodArray, isShown: $periodIsShown, value: self.$viewModel.model.periodLength, key: "PeriodLength") {
							self.periodIsShown.toggle()
							self.cycleIsShown = false
							self.startDateIsShown = false
						}
						LastDateItemView(date: self.$viewModel.model.periodStartDate, isShown: $startDateIsShown) {
							self.startDateIsShown.toggle()
							self.periodIsShown = false
							self.cycleIsShown = false
						}
						NotificationsItem(periodStartDate: self.viewModel.model.periodStartDate, cycle: self.viewModel.model.cycleLength, period: self.viewModel.model.periodLength)
					}
					.padding([.leading, .trailing], 24)
					Spacer()
					// TODO: add storekit items for donation
					LowerButton(text: "Rate the app in AppStore", action: {
//						if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//							SKStoreReviewController.requestReview(in: scene)
//						}
						self.requestReviewManually()
					})
				}
			}
			.modifier(BaseTextModifier())
		}
		.navigationBarHidden(true)
		.onAppear() {
			UserDefaults.standard.set(true, forKey: "NotFirstLaunch")
		}
    }

	func requestReviewManually() {
		let url = "https://apps.apple.com/app/id6451150560?action=write-review"
		guard let writeReviewURL = URL(string: url)
		else { fatalError("Expected a valid URL") }
		UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(viewModel: MainPeriodViewModel())
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
						.multilineTextAlignment(.leading)
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
		NavigationLink(destination: NotificationSettings(viewModel: NotificationSettingsViewModel(
			periodStartDate: self.periodStartDate,
			cycle: self.cycle,
			period: self.period
		))) {
			HStack {
				Text("Notifications")
					.foregroundColor(.black)
				Spacer()
				Image(systemName: "chevron.right")
					.foregroundColor(Color(UIColor(named: "secondButtonText") ?? .gray))
			}
		}
		.frame(height: 46)
	}
}

