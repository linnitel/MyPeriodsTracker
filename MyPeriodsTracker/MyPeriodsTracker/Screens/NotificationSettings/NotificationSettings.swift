//
//  NotificationSettings.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 20/06/2023.
//

import SwiftUI

struct NotificationSettings: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@ObservedObject var viewModel: NotificationSettingsViewModel

	@State private var showingAlert = false

	init(viewModel: NotificationSettingsViewModel) {
		self.viewModel = viewModel
		UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
	}

    var body: some View {
		ZStack(alignment: .top) {
			BackgroundView()
			VStack {
				ZStack(alignment: .center) {
					HStack(alignment: .center) {
						Button(action: {
							self.presentationMode.wrappedValue.dismiss()
						}) {
							Image(systemName: "arrow.left")
								.padding()
								.foregroundColor(.black)
						}
						Spacer()
					}
					Text("Notifications")
				}
				Group {
					NotificationsToggleItem(text: "Notifications", value: $viewModel.notificationsActive) {
						guard self.viewModel.isNotFirstTime else {
							self.viewModel.notifications.notificationRequest()
							// TODO: make some actions based on whether user allows notifications or not
							self.viewModel.isNotFirstTime = true
							return
						}

						guard self.viewModel.notificationsActive else {
							self.viewModel.notifications.cancelAllNotifications()
							return
						}

						self.viewModel.getGlobalNotification() {
							guard self.viewModel.globalNotificationsActive else {
								self.showingAlert = true

								self.viewModel.notificationsActive = false
								return
							}

							self.viewModel.schaduleNotifications()
						}
					}
					Group {
						NotificationsTimeItem(text: "Send at", time: $viewModel.notificationTime)
							.padding(.bottom, 40)
						NotificationsToggleItem(text: "One day before period", value: self.$viewModel.oneDayBefore, action: self.viewModel.schaduleOneDayBeforeNotification)
						NotificationsToggleItem(text: "Start of the period", value: self.$viewModel.startOfPeriod, action: self.viewModel.schadulePeriodFirstDayNotification)
						NotificationsToggleItem(text: "Ovulation", value: self.$viewModel.ovulation, action: self.viewModel.schaduleOvulationNotification)
					}
					.disabled(self.viewModel.notificationsActive == false)
				}
				.padding([.leading, .trailing], 24)
				.alert("Allow notifications", isPresented: $showingAlert) {
					Button("Go to settings") {
						if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
							UIApplication.shared.open(settingsURL)
						}
						
					}
					Button("Cancel") {
						self.showingAlert = false
					}
				} message: {
					Text("To recieve notificatons please allow it in the iPhone settings")
				}
			}
		}
		.navigationBarHidden(true)
		.modifier(BaseTextModifier())
		.onAppear() {
			self.viewModel.getGlobalNotification(completion: nil)
		}
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
		NotificationSettings(viewModel: NotificationSettingsViewModel(periodStartDate: Date(), cycle: 30, period: 5))
    }
}

struct NotificationsToggleItem: View {
	let text: String

	@Binding var value: Bool

	var action: (() -> Void)?

	var body: some View {
		VStack {
			Toggle(LocalizedStringKey(text), isOn: $value)
				.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				.padding([.bottom, .top], 16)
				.onChange(of: value) { value in
					if let action = action {
						action()
					}
				}
			DividerLineView()
		}
	}
}

struct NotificationsTimeItem: View {
	let text: String
	@State var isShown: Bool = false

	@Binding var time: Date

	var body: some View {
		VStack {
			HStack {
				Text(LocalizedStringKey(text))
				Spacer()
				Button {
					self.isShown.toggle()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.frame(width: 80, height: 40)
							.foregroundColor(.black.opacity(0.08))
						Text(time, style: .time)
					}
				}
			}
			.frame(height: 54)
			if isShown {
				DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
					.datePickerStyle(WheelDatePickerStyle())
			}
		}
	}

}
