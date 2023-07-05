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
					NotificationsToggleItem(text: "Notifications", key: "NotificationsActive", value: $viewModel.notificationsActive) {
						guard self.viewModel.isNotFirstTime else {
							self.viewModel.notifications.notificationRequest()
							self.viewModel.isNotFirstTime = true
							UserDefaults.standard.set(true, forKey: "IsNotFirstTimeNotification")
							return
						}

						guard self.viewModel.notificationsActive else { return }

						self.viewModel.getGlobalNotification() {
							guard !self.viewModel.globalNotificationsActive,
								  let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
							UIApplication.shared.open(settingsURL)
							// TODO: add alert whether to open settings or not
						}
					}
					NotificationsTimeItem(text: "Send at", time: $viewModel.notificationTime)
						.padding(.bottom, 40)
//					ForEach($viewModel.notificationsList) { $list in
//						NotificationsToggleItem(text: list.id, key: list.key, value: $list.subscribe)
//					}
				}
				.padding([.leading, .trailing], 24)
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
		NotificationSettings(viewModel: NotificationSettingsViewModel())
    }
}

struct NotificationsToggleItem: View {
	let text: String
	let key: String

	@Binding var value: Bool

	var action: (() -> Void)?

	var body: some View {
		VStack {
			Toggle(LocalizedStringKey(text), isOn: $value)
				.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				.padding([.bottom, .top], 16)
				.onChange(of: value) { value in
					UserDefaults.standard.set(value, forKey: key)
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
